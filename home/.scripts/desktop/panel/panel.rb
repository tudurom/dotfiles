#!/usr/bin/ruby

load `printf %s $HOME` + "/.scripts/setcolor"

BOLD_FONT_INDEX=2
ICON_FONT_INDEX=3

CLOCK_ICON   = "\u00c9"
SPEAKER_ICON = "\u00c6"
PLAYING_ICON = "\u00e6"
PAUSED_ICON  = "\u00e7"
STOPPED_ICON = "\u00e5"
BATTERY_CHARGING_ICON = "\u00c2"
BATTERY_FULL_ICON = "\u00f0"
BATTERY_HALF_ICON = "\u00ef"
BATTERY_EMPTY_ICON = "\u00ee"

#puts $colors["BG_COLOR"]

def bold(text)
  return "%{T#{BOLD_FONT_INDEX}}#{text}%{T-}"
end

def fg(color, text)
  return "%{F#{color}}#{text}%{F-}"
end

def bg(color, text)
  return "%{B#{color}}#{text}%{B-}"
end

def icon(icon)
  return "%{T#{ICON_FONT_INDEX}}#{icon}%{T-}"
end

def separator
  return fg($colors["BG_COLOR"], " | ")
end

class Button
  def initialize(i, command)
    @i = i
    @command = command
  end

  def i
    return @i
  end

  def command
    return @command
  end
end

def click(text, buttons)
  out = ""
  buttons.each do |b|
    out += "%{A#{b.i}:#{b.command}:}"
  end
  out += text
  buttons.each do |b|
    out += "%{A}"
  end
  return out
end

class Widget

  def initialize()
    @align = :l
  end

  def update()
  end

  def render()
  end

  def out()
  end

  def align()
    return @align
  end

end

class WidgetManager < Widget

  def initialize()
    @widgets = { :l => [], :c => [], :r => [] }
  end

  def add(widget)
    @widgets[widget.align].push widget
  end

  def update()
    @out = ""
    @widgets.each do |align, widgets_with_align|
      @out += "%{#{align.to_s}}"
      widgets_with_align.each_with_index do |widget, index|
        widget.update
        @out += widget.out
        if index < widgets_with_align.length - 1
          widgets_with_align[index + 1].update
          if widgets_with_align[index + 1].out.strip != ""
            @out += separator
          end
        end
      end
    end

  end

  def render()
    puts @out
  end

  def out()
    return @out
  end
end



class HLWMTags < Widget


  def out()
    return @out
  end

  def update()
    tags = `herbstclient tag_status`.split()
    @out = "%{T-}"

    tags.each_with_index do |tag, index|
      button = Button.new(1, "herbstclient use_index #{index}")
      text = click(" " + tag[1..tag.length - 1] + " ", [button])
      #puts text
      if tag[0] == '#'
        @out += bg($colors["BG_COLOR"], fg("#101010", text))
      elsif tag[0] == '+'
        @out += bg($colors["INACTIVE_BG_COLOR"], fg("#141414", text))
      elsif tag[0] == ':'
        @out += bg("-", fg("#ffffff", text))
      elsif tag[0] == '!'
        @out += bg($colors["URGENT_BG_COLOR"], fg("#141414", text))
      else
        @out += bg("-", fg("#ababab", text))
      end
    end
    @out += separator + fg("#ababab", `xtitle`.strip())

  end

  def render()
    puts @out
    STDOUT.flush
  end
end

class TimeW < Widget

  def initialize
    @align = :r
  end

  def update()
    @out = icon(CLOCK_ICON) + " " + Time.now.strftime("%A, %m %B %I:%M %p")
  end

  def render()
    print @out
  end

  def out()
    return @out
  end
end

class PlayerctlW < Widget

  def initialize
    @align = :r
  end

  def update()
    status = `playerctl status`.strip()
    if status != ""
      statuses = {
        "Playing" => PLAYING_ICON,
        "Paused"  => PAUSED_ICON,
        "Stopped" => STOPPED_ICON
      }
      buttons = []
      buttons[0] = Button.new(1, "playerctl play-pause")
      buttons[1] = Button.new(3, "playerctl stop")
      artist = `playerctl metadata artist`
      title = `playerctl metadata title`
      @out = "#{icon(statuses[status])} #{click(bold(artist + ' - ' + title), buttons)} "
    else
      @out = " "
    end
  end

  def render()
    print @out
  end

  def out()
    return @out
  end
end

class VolumeW < Widget

  def initialize
    @align = :r
  end
  def update()
    buttons = [Button.new(3, "amixer -D pulse sset Master toggle"),
               Button.new(4, "amixer -D pulse sset Master 5%+"),
               Button.new(5, "amixer -D pulse sset Master 5%-")]


    @out = "#{icon(SPEAKER_ICON)} " + click(`~/.scripts/desktop/panel/volume`.strip.chomp('%'), buttons)
  end

  def out()
    return @out
  end

  def render()
    print @out
  end
end

class BatteryW < Widget

  def initialize
    @align = :r
  end

  def update
    regex = /(\w+), (\d+)%(, (\d+):(\d+):(\d+))?/
    out = `acpi -b`
    regex.match(out)
    status = $~[1]
    percentage = $~[2].to_i
    hours = $~[4]
    minutes = $~[5]
    icon = ""
    if status == "Charging"
      icon = BATTERY_CHARGING_ICON
    elsif percentage >= 50
      icon = BATTERY_FULL_ICON
    elsif percentage < 50 and percentage >= 20
      icon = BATTERY_HALF_ICON
    else
      icon = BATTERY_EMPTY_ICON
    end

    @out = icon(icon) + " " + percentage.to_s
    if hours != nil
      @out += " (#{hours}:#{minutes})"
    end
  end

  def out
    return @out
  end

  def render
    print @out
  end
end

tags = HLWMTags.new
time = TimeW.new
volume = VolumeW.new
batt = BatteryW.new
pctl = PlayerctlW.new
manager = WidgetManager.new
manager.add tags
manager.add time
manager.add volume
manager.add batt
manager.add pctl

while true
  manager.update()
  manager.render()
  sleep(0.1)
end

#!/usr/bin/ruby

load `printf %s $HOME` + "/.scripts/setcolor"

BOLD_FONT_INDEX=2
ICON_FONT_INDEX=3

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
  end

  def update()
  end

  def render()
  end

  def out()
  end

end

class WidgetManager < Widget

  def initialize()
    @widgets = []
  end

  def add(widget)
    @widgets.push widget
  end

  def update()
    @widgets.each do |widget|
      widget.update()
    end
    @out = ""
    @widgets.each do |widget|
      @out += widget.out + " "
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

  def initialize()
  end

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

  def update()
    @out = "%{r}" + icon("\uf017") + " " + `date +"%A, %d %B %H:%I"`.strip + separator
  end

  def render()
    print @out
  end

  def out()
    return @out
  end
end

class PlayerctlW < Widget

  def update()
    status = `playerctl status`.strip()
    if status != ""
      statuses = {
        "Playing" => "\uf04b",
        "Paused"  => "\uf04c",
        "Stopped" => "\uf04d"
      }
      buttons = []
      buttons[0] = Button.new(1, "playerctl play-pause")
      buttons[1] = Button.new(3, "playerctl stop")
      artist = `playerctl metadata artist`
      title = `playerctl metadata title`
      @out = bold("#{icon(statuses[status])} #{click(artist + ' - ' + title, buttons)}")
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

  def update()
    buttons = [Button.new(3, "amixer -D pulse sset Master toggle"),
               Button.new(4, "amixer -D pulse sset Master 5%+"),
               Button.new(5, "amixer -D pulse sset Master 5%-")]


    @out = "#{icon("\uf028")} " + `~/.scripts/desktop/panel/volume`.strip.chomp('%') + separator
  end

  def out()
    return @out
  end

  def render()
    print @out
  end
end

tags = HLWMTags.new
time = TimeW.new
volume = VolumeW.new
pctl = PlayerctlW.new
manager = WidgetManager.new
manager.add tags
manager.add time
manager.add volume
manager.add pctl

while true
  manager.update()
  manager.render()
  sleep(0.1)
end

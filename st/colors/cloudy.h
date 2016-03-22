/*

┏━╸╻  ┏━┓╻ ╻╺┳┓╻ ╻
┃  ┃  ┃ ┃┃ ┃ ┃┃┗┳┛
┗━╸┗━╸┗━┛┗━┛╺┻┛ ╹
by tudurom.

*/

/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {
	/* 8 normal colors */
	"#273941",
	"#a66363",
	"#63a690",
	"#a6a663",
	"#6385a6",
	"#bf9c86",
	"#63a69b",
	"#c0c5ce",

	/* 8 bright colors */
	"#456472",
	"#c27171",
	"#6dc2a3",
	"#bfc271",
	"#719bc2",
	"#bf9c86",
	"#71c2af",
	"#eff1f5",

	[255] = 0,
};


/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
static unsigned int defaultfg = 7;
static unsigned int defaultbg = 0;
static unsigned int defaultcs = 7;

/*
 * Colors used, when the specific fg == defaultfg. So in reverse mode this
 * will reverse too. Another logic would only make the simple feature too
 * complex.
 */
static unsigned int defaultitalic = 11;
static unsigned int defaultunderline = 7;

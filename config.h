/* See LICENSE file for copyright and license details. */

/* appearance */
// #include <cmath>
static const unsigned int borderpx = 2; /* border pixel of windows */
static const unsigned int snap = 32;    /* snap pixel */
static const unsigned int gappih = 7;   /* horiz inner gap between windows */
static const unsigned int gappiv = 7;   /* vert inner gap between windows */
static const unsigned int gappoh =
    10; /* horiz outer gap between windows and screen edge */
static const unsigned int gappov =
    10; /* vert outer gap between windows and screen edge */
static int smartgaps =
    0; /* 1 means no outer gap when there is only one window */
static const int showbar = 1;       /* 0 means no bar */
static const int topbar = 1;        /* 0 means bottom bar */
static const Bool viewontag = True; /* Switch view on tag switch */
static const char *fonts[] = {
    "Symbols Nerd Font:sytle=2048-em:size=11",
    "monospace:size=10",
    "SimSun:size=10",
};
static const char dmenufont[] = "monospace:size=10";
static const unsigned int baralpha = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char col_cyan[] = "#cba6f7";
static const char col_dra_blue[] = "#6272a4";
static const char col_blue[] = "#89cff0";
static const char col_orange[] = "#ffc000";
static const char *colors[][4] = {
    /*               fg         bg         border      float*/
    [SchemeNorm] = {col_gray3, col_gray1, col_dra_blue, col_blue},
    [SchemeSel] = {col_cyan, col_gray1, col_cyan, col_cyan},
};
static const unsigned int alphas[][3] = {
    /*               fg      bg        border*/
    [SchemeNorm] = {OPAQUE, baralpha, borderalpha},
    [SchemeSel] = {OPAQUE, baralpha, borderalpha},
};

static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = {"alacritty", "-T", scratchpadname, NULL};

static const char wudaoname[] = "wudao";
// static const char *wudao[] = { "alacritty", "-T", "wudao", "-e", "zsh", "-c",
// "wd -i; exec sh", NULL };
static const char *wudao[] = {"alacritty",
                              "-T",
                              "wudao",
                              "-e",
                              "zsh",
                              "-c",
                              "source ~/.zshrc; wd -i; exec sh",
                              NULL};

/* tagging */
static const char *tags[] = {"󰎤", "󰎧", "󰎪", "󰎭", "󰎱",
                             "󰎳", "󰎶", "",  ""};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"Gimp", NULL, NULL, 0, 0, -1},
    {"Firefox", NULL, NULL, 1 << 8, 0, -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT                                                           \
  1 /* nrowgrid layout: force two clients to always split vertically */
#include "exitdwm.c"
#include "vanitygaps.c"

static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]=", tile}, /* first entry is default */
    {"[M]", monocle},
    {"[@]", spiral},
    {"[\\]", dwindle},
    {"H[]", deck},
    {"TTT", bstack},
    {"===", bstackhoriz},
    {"HHH", grid},
    {"###", nrowgrid},
    {"---", horizgrid},
    {":::", gaplessgrid},
    {"|M|", centeredmaster},
    {">M>", centeredfloatingmaster},
    {"><>", NULL}, /* no layout function means floating behavior */
    {NULL, NULL},
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, comboview, {.ui = 1 << TAG}},                                  \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, combotag, {.ui = 1 << TAG}},                   \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
    "dmenu_run", "-m",      dmenumon, "-fn",    dmenufont, "-nb",     col_gray1,
    "-nf",       col_gray3, "-sb",    col_cyan, "-sf",     col_gray4, NULL};
static const char *rofi[] = {"rofi", "-show", "drun"};
static const char *termcmd[] = {"kitty", NULL};

static const Key keys[] = {
    /* modifier                     key        function        argument */
    // { MODKEY,                       XK_d,      spawn,          {.v = dmenucmd
    // } },
    {MODKEY, XK_d, spawn, {.v = rofi}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_s, togglescratch, {.v = scratchpadcmd}},
    {MODKEY, XK_w, togglewudao, {.v = wudao}},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_v, incnmaster, {.i = -1}},
    {MODKEY, XK_comma, setmfact, {.f = -0.05}},
    {MODKEY, XK_period, setmfact, {.f = +0.05}},
    {MODKEY, XK_e, zoom, {0}},
    {MODKEY | Mod4Mask, XK_u, incrgaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_u, incrgaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_i, incrigaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_i, incrigaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_o, incrogaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_o, incrogaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_6, incrihgaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_6, incrihgaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_7, incrivgaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_7, incrivgaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_8, incrohgaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_8, incrohgaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_9, incrovgaps, {.i = +1}},
    {MODKEY | Mod4Mask | ShiftMask, XK_9, incrovgaps, {.i = -1}},
    {MODKEY | Mod4Mask, XK_0, togglegaps, {0}},
    {MODKEY | Mod4Mask | ShiftMask, XK_0, defaultgaps, {0}},
    // { MODKEY,                       XK_Tab,    view,           {0} },
    {MODKEY | ShiftMask, XK_q, killclient, {0}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
    // { MODKEY,                       XK_f,      setlayout,      {.v =
    // &layouts[1]} },
    {MODKEY, XK_f, toggle_layout, {0}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
    // 	{ MODKEY,                       XK_e,      setlayout,      {0} },
    {MODKEY, XK_space, togglefloating, {0}},
    {MODKEY | ShiftMask, XK_f, togglefullscr, {0}},
    // { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_h, focusmon, {.i = -1}},
    {MODKEY, XK_l, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_h, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_l, tagmon, {.i = +1}},
    {MODKEY, XK_Tab, focusmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_Tab, tagmon, {.i = -1}},
    {MODKEY, XK_p, spawn,
     SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume "
           "@DEFAULT_AUDIO_SINK@ 5%+ && ~/.dwm/reflashBar.sh")},
    {MODKEY | ShiftMask, XK_p, spawn,
     SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume "
           "@DEFAULT_AUDIO_SINK@ 5%- && ~/.dwm/reflashBar.sh")},
    {MODKEY, XK_o, spawn,
     SHCMD("~/Applications/"
           "Obsidian-1.6.7_fbe5be623488d0ecebb94f3b174ba197.AppImage")},
    {MODKEY | ShiftMask, XK_Return, spawn, SHCMD("brave")},
    //{ MODKEY|ShiftMask,             XK_x,      spawn,          SHCMD("maim -s
    //~/Pictures/Screenshots/$(date +%Y-%b-%d--%H-%M-%S_maim | tr A-Z a-z).png")
    //},
    {MODKEY, XK_x, spawn, SHCMD("flameshot gui -p ~/Pictures/Screenshots/")},
    {MODKEY | ShiftMask, XK_x, spawn,
     SHCMD("flameshot screen -p ~/Pictures/Screenshots/ && paplay "
           "/usr/share/sounds/freedesktop/stereo/screen-capture.oga")},
    {MODKEY, XK_u, spawn, SHCMD("/home/silver/.dwm/trayer.sh")},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8)
    // { MODKEY|ShiftMask,             XK_e,      quit,           {0} },
    {MODKEY | ShiftMask, XK_e, exitdwm, {0}},
    {MODKEY | ControlMask | ShiftMask, XK_e, quit, {1}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};

global.options = {
    audio : {
        master  : 80,
        music   : 20,
        sfx     : 60,
    },
    video : {
        display : 1,
        resolution : 1,
        bloom : true,
        vsync : false,
    },
    language : "pt_BR",
}
global.debug = false;

scribble_font_set_default("fnt_test");

menuData = {
    sizeMode: 2,
    fixedWid: 300,
    fixedHei: 80,
    padding: [4, 4, 4, 4],
    margin: [4, 4, 4, 4],
    hAlign: 2,
    vJustify: 2,
    anchor: 3,
}

//room_goto(rm_menu);
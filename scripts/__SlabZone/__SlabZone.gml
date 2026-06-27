/*

var _zones = [
    zoneButton,
    zoneButton,
    zoneCheckbox,
    zoneSelector,
    zoneSelector,
    zoneSlider,
    zoneSlider,
    zoneSlider,
    zoneButton
]

for (var i = 0; i < array_length(_zones); i++) {
    SlabDrawZones(SlabResolveZones(_zones[i], 32, 32 + i*48, 512, 32))
}

*/


// Button
zoneButton = [
    
]

// Checkbox
zoneCheckbox = [
    { name: "BOX", anchor: "RIGHT", align: "CENTER", w: 32, h: "fill" },
]

// Selector
zoneSelector = [
    { name: "LABEL", w: "50%" },
    { w: "fill", children: [
        { name: "LEFT",  anchor: "LEFT",  w: 32 },
        { name: "VALUE", anchor: "LEFT",  w: "fill" },
        { name: "RIGHT", anchor: "RIGHT", w: 32 },
    ]},
]

// Slider
zoneSlider = [
    { name: "LABEL", w: "50%" },
    { w: "fill", children: [
        { name: "BAR", anchor: "LEFT", w: "fill", h: "50%" },
        { name: "VALUE", anchor: "RIGHT", w: 48 },
    ]},
]

function SlabResolveZones(zones, nx, ny, nw, nh) {
    
    // Default BODY if no zones defined
    if (is_undefined(zones) || array_length(zones) == 0) {
        return [{ name: "BODY", rx: nx, ry: ny, rw: nw, rh: nh }];
    }
    
    return __slab_resolve_node(zones, nx, ny, nw, nh);
}

function __slab_resolve_node(zones, px, py, pw, ph) {
    var _result = [];
    var _remaining = pw;
    var _fill_count = 0;
    
    array_push(_result, { name: "BODY", rx: px, ry: py, rw: pw, rh: ph });
    
    // Pass 1 — measure fixed + percent
    for (var i = 0; i < array_length(zones); i++) {
        var _z = zones[i];
        var _w = _z.w ?? "fill";

        if (is_real(_w)) {
            _remaining -= _w;
        } else if (string_pos("%", _w) > 0) {
            _remaining -= (real(string_replace(_w, "%", "")) / 100) * pw;
        } else if (_w == "fill") {
            _fill_count++;
        }
    }

    var _fill_w = (_fill_count > 0) ? (_remaining / _fill_count) : 0;

    // Pass 2 — assign positions, left and right cursors
    var _cursor_l = px;
    var _cursor_r = px + pw;

    for (var i = 0; i < array_length(zones); i++) {
        var _z = zones[i];
        var _w = _z.w ?? "fill";
        var _rw = 0;

        if (is_real(_w))                  _rw = _w;
        else if (string_pos("%", _w) > 0) _rw = (real(string_replace(_w, "%", "")) / 100) * pw;
        else if (_w == "fill")            _rw = _fill_w;

        var _h = _z[$ "h"] ?? "fill";
        var _rh = 0;
        if (is_real(_h))                  _rh = _h;
        else if (string_pos("%", _h) > 0) _rh = (real(string_replace(_h, "%", "")) / 100) * ph;
        else if (_h == "fill")            _rh = ph;
        var _rx, _ry;

        if ((_z[$ "anchor"] ?? "LEFT") == "RIGHT") {
            _cursor_r -= _rw;
            _rx = _cursor_r;
        } else {
            _rx = _cursor_l;
            _cursor_l += _rw;
        }
        _ry = py + (ph - _rh) / 2;

        // Named zone — add to result
        if (_z[$ "name"] != undefined) {
            array_push(_result, { name: _z.name, rx: _rx, ry: _ry, rw: _rw, rh: _rh });
        }

        // Recurse into children
        if (_z[$ "children"] != undefined) {
            var _children = __slab_resolve_node(_z.children, _rx, _ry, _rw, _rh);
            for (var j = 0; j < array_length(_children); j++) {
                array_push(_result, _children[j]);
            }
        }
    }

    return _result;
}

function SlabDrawZones(resolved) {
    for (var i = 0; i < array_length(resolved); i++) {
        var _r = resolved[i];
        var _c1 = 0x0000FF;
        var _c2 = 0x00FF00;
        draw_rectangle_color(_r.rx, _r.ry, _r.rx + _r.rw, _r.ry + _r.rh, _c1, _c2, _c1, _c2, true);
    }
}
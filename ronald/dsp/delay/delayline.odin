package delay

import "../../consts"

DelayLine :: struct {
    r, w: uint, // both same for now
    buf: [consts.MAX_DELAY]f64,
}

// line_tick :: proc (line: ^DelayLine, s: f64) -> f64 {
//     out := line.buf[line.r]
//     line.buf[line.w] = s
//     line.w = (line.w + 1) % consts.MAX_DELAY
//     line.r = (line.r + 1) % consts.MAX_DELAY
//     return out
// }

line_tick :: proc (line: ^DelayLine, s, fb: f64) -> f64 {
    out := line.buf[line.r]
    line.buf[line.w] *= fb
    line.buf[line.w] += s
    line.w = (line.w + 1) % consts.MAX_DELAY
    line.r = (line.r + 1) % consts.MAX_DELAY
    return out
}

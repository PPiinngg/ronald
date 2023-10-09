package ronald

import "clap"
import "clap/ext"
import "consts"
import "dsp/delay"

State :: struct {
    plugin:            clap.Plugin,
    host:              ^clap.Host,
    host_latency:      ^ext.Host_Latency,
    host_log:          ^ext.Host_Log,
    host_thread_check: ^ext.Host_Thread_Check,
    host_state:        ^ext.Host_State,

    delayline: delay.DelayLine,

    latency: u32,
}

init :: proc "c" (plugin: ^clap.Plugin) -> bool {
    return true
}

destroy :: proc "c" (plugin: ^clap.Plugin) {}

activate :: proc "c" (plugin: ^clap.Plugin, sample_rate: f64, min_frames, max_frames: u32) -> bool {
    return true
}

deactivate :: proc "c" (plugin: ^clap.Plugin) {}

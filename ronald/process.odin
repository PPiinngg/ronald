package ronald

import "core:runtime"
import "clap"
import "dsp/delay"

start_processing :: proc "c" (plugin: ^clap.Plugin) -> bool {
    return true
}

stop_processing :: proc "c" (plugin: ^clap.Plugin) {}

reset :: proc "c" (plugin: ^clap.Plugin) {}

delayline := delay.DelayLine{}

process :: proc (
	$T: typeid,
	plugin: ^clap.Plugin,
	ch_c, frm_c: u32,
	i_buf, o_buf: [^][^]T,
	process: ^clap.Process
) {
	state := cast(^State)plugin.plugin_data
	events := process.in_events



	// o_ch := o_buf[ch_i]
	// i_ch := i_buf[ch_i]
	
	for frm_i in 0..<frm_c {
		for ch_i in 0..<ch_c {


			// We just use f64 internally to avoid dealing with generics everywhere
			s := f64(i_buf[ch_i][frm_i])
			o := delay.line_tick(state.delayline, s, 0.9)
			// o := s
			i_buf[ch_i][frm_i] = T(o)
		}
	}
}

init_process :: proc "c" (plugin: ^clap.Plugin, clap_process: ^clap.Process) -> clap.Process_Status {
	context = runtime.default_context()

    main_in := clap_process.audio_inputs[0]
    main_out := clap_process.audio_outputs[0]

	ch_c := clap_process.audio_inputs[0].channel_count
	frm_c := clap_process.frames_count
    
    if clap_process.audio_outputs[0].data32 != nil {
		process(f32, plugin, ch_c, frm_c, main_in.data32, main_out.data32, clap_process)
    } else if clap_process.audio_outputs[0].data64 != nil {
		process(f64, plugin, ch_c, frm_c, main_in.data64, main_out.data64, clap_process)
    }

    return clap.Process_Status.CONTINUE
}

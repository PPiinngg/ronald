package ronald

import "base:runtime"
import "clap"
import "core:fmt"
import "dsp/delay"

start_processing :: proc "c" (plugin: ^clap.Plugin) -> bool {
	return true
}

stop_processing :: proc "c" (plugin: ^clap.Plugin) {}

reset :: proc "c" (plugin: ^clap.Plugin) {}

delayline := delay.DelayLine{}

process :: proc (
	plugin: ^clap.Plugin,
	ch_c, frm_c: u32,
	i_buf, o_buf: [^][^]f32,
	process: ^clap.Process,
) {
	state := cast(^State)plugin.plugin_data
	events := process.in_events

	for frm_i in 0 ..< frm_c {
		for ch_i in 0 ..< ch_c {

			s := i_buf[ch_i][frm_i]
			o := s
			o := delay.line_tick(state.delayline, s, 0.9)

			i_buf[ch_i][frm_i] = o
		}
	}
}

init_process :: proc "c" (
	plugin: ^clap.Plugin,
	clap_process: ^clap.Process,
) -> clap.Process_Status {
	context = runtime.default_context()

	main_in := clap_process.audio_inputs[0]
	main_out := clap_process.audio_outputs[0]

	ch_c := clap_process.audio_inputs[0].channel_count
	frm_c := clap_process.frames_count

	process(plugin, ch_c, frm_c, main_in.data32, main_out.data32, clap_process)

	return clap.Process_Status.CONTINUE
}

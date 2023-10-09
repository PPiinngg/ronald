package ronald

import "clap"

descriptor := clap.Plugin_Descriptor{
	clap_version = clap.CLAP_VERSION,
	id          = "dev.glyphli.ronald",
	name        = "Ronald",
	vendor      = "Glyphli",
	url         = "https://github.com/PPiinngg/clap-odin",
	manual_url  = "https://github.com/PPiinngg/clap-odin/blob/main/README.md",
	support_url = "https://github.com/PPiinngg/clap-odin/issues",
	verison     = "0.0.1",
	description = "Funny resonator",
	features    = raw_data([]cstring{
		clap.PLUGIN_FEATURE_AUDIO_EFFECT,
		clap.PLUGIN_FEATURE_STEREO,
		clap.PLUGIN_FEATURE_FILTER,
		nil,
	}),
}

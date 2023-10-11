package ronald

import "core:runtime"
import "core:strings"
import "core:c/libc"
import "clap"
import "clap/ext"
import "consts"

str_u8_len :: proc (str: string, $len: int) -> [^]u8 {
    str_u8 := transmute([]u8)str
    out := [len]u8{}
    for chr, i in str_u8 {
        out[i] = chr
    }
    return raw_data(&out)
}

ParamDefine :: struct {
    name, path: string,
    vmin, vmax, vdef: f64,
    flags: u32,
}

define_params :: []ParamDefine{
    ParamDefine{
        name  = "TEST",
        path  = "jamble",
        vmin  = 1, vmax = consts.MAX_DELAY,
        vdef  = consts.MAX_DELAY / 2,
        flags = u32(
            ext.Param_Info_Flag.STEPPED
        )
    },
}

Parameter :: struct {
    info: ext.Param_Info,
    v: f64,
}

make_param_arr :: proc (defs: []ParamDefine) -> [dynamic]Parameter {
    out := make([dynamic]Parameter, len(defs))
    for def, i in defs {
        param := Parameter{}
        param.info.id = u32(i)
        param.info.flags = def.flags
        param.info.cookie = &param
        param.info.name = strings.clone_to_cstring(def.name)
        param.info.module = strings.clone_to_cstring(def.path)
        param.info.min_value = def.vmin
        param.info.max_value = def.vmax
        param.info.default_value = def.vdef
        param.v = def.vdef
        out[i] = param
    }
    return out
}

params := ext.Plugin_Params{
    count = proc "c" (plugin: ^clap.Plugin) -> u32 {
        state := cast(^State)plugin.plugin_data
        return u32(len(state.params))
    },


    get_info = proc "c" (plugin: ^clap.Plugin, param_index: u32, param_info: ^ext.Param_Info) -> bool {
        state := cast(^State)plugin.plugin_data
        param_info^ = state.params[param_index].info
        return true
    },


    get_value = proc "c" (plugin: ^clap.Plugin, param_id: clap.Clap_Id, out_value: ^f64) -> bool {
        state := cast(^State)plugin.plugin_data
        out_value^ = state.params[param_id].v
        return true
    },


    value_to_text = proc "c" (plugin: ^clap.Plugin, param_id: clap.Clap_Id, value: f64, out_buffer: cstring, out_buffer_capacity: u32) -> bool {
        context = runtime.default_context()
        sb := strings.builder_make()
        strings.write_f64(&sb, value,'f',false)
        out_str := strings.to_string(sb)
        libc.strncpy(
            transmute([^]u8)out_buffer,
            strings.clone_to_cstring(out_str),
            6
        )
        return true
    },


    text_to_value = proc "c" (plugin: ^clap.Plugin, param_id: clap.Clap_Id, param_value_text: cstring, out_value: ^f64) -> bool {
        state := cast(^State)plugin.plugin_data
        end_ptr : [^]u8 = nil
        state.params[param_id].v = libc.strtod(param_value_text, &end_ptr)
        return true
    },


    flush = proc "c" (plugin: ^clap.Plugin, in_events: ^clap.Input_Events, out_events: ^clap.Output_Events) {
        // state := cast(^State)plugin.plugin_data
    },
}

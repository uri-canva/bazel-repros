"""foo sources"""

def _foo_impl(ctx):
    unused_inputs_list = ctx.actions.declare_file("unused_inputs_list")
    ctx.actions.run_shell(
        outputs = [unused_inputs_list],
        command = "echo > {unused_inputs_list}".format(unused_inputs_list = unused_inputs_list.path),
        use_default_shell_env = True,
    )
    ctx.actions.run(
        outputs = [ctx.outputs.out],
        inputs = ctx.files.srcs + [ctx.executable._cat, unused_inputs_list],
        executable = ctx.executable._cat.path,
        arguments = [ctx.outputs.out.path] + [s.path for s in ctx.files.srcs],
        unused_inputs_list = unused_inputs_list,
    )

foo = rule(
    implementation = _foo_impl,
    doc = "foo the input sources.",
    attrs = {
        "srcs": attr.label_list(
            doc = "The input sources.",
            mandatory = True,
            allow_files = True,
        ),
        "_cat": attr.label(
            default = Label("//:cat"),
            executable = True,
            cfg = 'host',
        )
    },
    outputs = {
        "out": "%{name}.txt",
    }
)

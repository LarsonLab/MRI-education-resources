"""Remove code-cell source from LaTeX/PDF builds only.

HTML keeps the source behind a toggle via the `hide-input` cell tag.
"""


def _on_builder_inited(app):
    if app.builder.name in ("latex", "pdflatex"):
        app.config.nb_remove_code_source = True


def setup(app):
    app.connect("builder-inited", _on_builder_inited, priority=900)
    return {"parallel_read_safe": True}

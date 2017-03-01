name-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title { title }
        #{'yield'}(to="body")
            form(onchange='{ change }', onkeyup='{ change }')
                .form-group(class='{ has-error: error.name }')
                    label.control-label { label }
                    input.form-control(name='name', type='text', value='{ value }', autofocus)
                    .help-block { error.name }
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Отмена
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') { button }

    script(type='text/babel').
        var self = this

        self.on('mount', () => {
            let modal = self.tags['bs-modal']

            modal.item = {}
            modal.value = opts.value
            modal.mixin('validation')
            modal.mixin('change')
            modal.label = !!opts.label ? opts.label : "Наименование"
            modal.title = !!opts.title ? opts.title : "Добавить"
            modal.button = !!opts.button ? opts.button : "Сохранить"

            modal.rules = {
                name: 'empty'
            }

            modal.afterChange = e => {
                modal.error = modal.validation.validate(modal.item, modal.rules, e.target.name)
            }

            modal.one('updated', () => {
                modal.autofocus()
            })
        })
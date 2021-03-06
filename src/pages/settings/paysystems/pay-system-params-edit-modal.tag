pay-system-params-edit-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title { parent.opts.title || 'Новый параметр' }
        #{'yield'}(to="body")
            form(onchange='{ change }', onkeyup='{ change }')
                .row
                    .col-md-12
                        .form-group(class='{ has-error: error.key }')
                            label.control-label Код
                            input.form-control(name='key', value='{ item.key }', disabled='{ !isNew }')
                            .help-block { error.key }
                .row
                    .col-md-12
                        .form-group(class='{ has-error: error.name }')
                            label.control-label Заголовок
                            input.form-control(name='name', value='{ item.name }', disabled='{ !isNew }')
                            .help-block { error.name }
                .row
                    .col-md-12
                        .form-group(class='{ has-error: error.value }')
                            label.control-label Значение
                            input.form-control(name='value', value='{ item.value }')
                            .help-block { error.value }

        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit }', type='button', class='btn btn-primary btn-embossed') Сохранить

        script(type='text/babel').
            var self = this

            self.on('mount', () => {
                let modal = self.tags['bs-modal']

                modal.error = false
                modal.isNew = opts.isNew || false
                modal.item = opts.item || {}
                modal.mixin('validation')
                modal.mixin('change')

                modal.rules = {
                    key: 'empty',
                    name: 'empty',
                    value: 'empty'
                }

                modal.afterChange = e => {
                    let name = e.target.name
                    delete modal.error[name]
                    modal.error = {...modal.error, ...modal.validation.validate(modal.item, modal.rules, name)}
                }
            })
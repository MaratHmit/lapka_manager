| import parallel from 'async/parallel'
| import 'components/name-modal.tag'

delivery-edit
    loader(if='{ loader }')
    virtual(hide='{ loader }')
        .btn-group
            a.btn.btn-default(href='#settings/delivery') #[i.fa.fa-chevron-left]
            button.btn.btn-default(if='{ checkPermission("deliveries", "0010") }', onclick='{ submit }', type='button')
                i.fa.fa-floppy-o
                |  Сохранить
            button.btn.btn-default(if='{ !isNew }', onclick='{ reload }', title='Обновить', type='button')
                i.fa.fa-refresh
        .h4 { isNew ? item.name || 'Добавление доставки' : item.name || 'Редактирование доставки' }

        form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
            .row
                .col-md-3
                    .form-group(class='{ has-error: error.name }')
                        label.control-label Наименование
                        input.form-control(name='name', value='{ item.name }')
                        .help-block { error.name }
            .row
                .col-md-12
                    .form-group
                        label.control-label Примечание
                        textarea.form-control(name='note', rows='5', style='min-width: 100%; max-width: 100%;',
                        value='{ item.note }')

            .row(if='{ item.code == "pickup" }')
                .col-md-12
                    .panel.panel-default
                        .panel-heading
                            h4.panel-title Пункты самовывоза
                        .panel-body
                            catalog-static(name='points', rows='{ item.points }',
                                cols='{ pointsCols }', add='{ addPoint }', dblclick='{ editPoint }')
                                #{'yield'}(to='body')
                                    datatable-cell(name='address') { row.address }
            .row(if='{ item.code == "courier" }')
                .col-md-12
                    .panel.panel-default
                        .panel-heading
                            h4.panel-title Временные интервалы
                        .panel-body
                            catalog-static(name='periods', rows='{ item.periods }',
                            cols='{ periodsCols }', add='{ addPeriod }', dblclick='{ editPeriod }')
                                #{'yield'}(to='body')
                                    datatable-cell(name='name') { row.name }


    script(type='text/babel').
        var self = this

        self.mixin('validation')
        self.mixin('permissions')
        self.mixin('change')
        self.item = {}

        self.pointsCols = [
            {name: 'address', value: 'Адрес пункта'}
        ]

        self.periodsCols = [
            {name: 'name', value: 'Период'},
        ]

        self.rules = {
            name: 'empty',
        }

        self.afterChange = e => {
            let name = e.target.name
            delete self.error[name]
            self.error = {...self.error, ...self.validation.validate(self.item, self.rules, name)}
        }

        self.addPoint = () => {
            modals.create('name-modal', {
                type: 'modal-primary',
                title: 'Пункт самовывоза',
                label: 'Адрес пункта самовывоза',
                button: 'Добавить',
                submit() {
                    self.item.points.push({ address: this.name.value })
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.editPoint = (e) => {
            let item
            if (e && e.item)
                item = e.item.row
            else return

            modals.create('name-modal', {
                type: 'modal-primary',
                title: 'Пункт самовывоза',
                label: 'Адрес пункта самовывоза',
                button: 'Сохранить',
                value: item.address,
                submit() {
                    item.address = this.name.value
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.addPeriod = () => {
            modals.create('name-modal', {
                type: 'modal-primary',
                title: 'Период',
                label: 'Временной интервал',
                button: 'Добавить',
                submit() {
                    self.item.periods.push({ name: this.name.value })
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.editPeriod = (e) => {
            let item
            if (e && e.item)
                item = e.item.row
            else return

            modals.create('name-modal', {
                type: 'modal-primary',
                title: 'Период',
                label: 'Временной интервал',
                button: 'Сохранить',
                value: item.name,
                submit() {
                    item.name = this.name.value
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.submit = () => {
            self.error = self.validation.validate(self.item, self.rules)

            if (!self.error) {
                self.loader = true

                API.request({
                    object: 'Delivery',
                    method: 'Save',
                    data: self.item,
                    success(response) {
                        self.item = response
                        observable.trigger('delivery-reload')
                        popups.create({title: 'Успех!', text: 'Доставка сохранена!', style: 'popup-success'})
                    },
                    complete(){
                        self.loader = false
                        self.update()
                    }
                })
            }
        }

        self.reload = () => {
            observable.trigger('delivery-edit', self.item.id)
        }

        observable.on('delivery-edit', id => {
            let params = {id: id}
            self.error = false
            self.isNew = false
            self.item = {}
            self.loader = true
            self.update()

            API.request({
                object: 'Delivery',
                method: 'Info',
                data: params,
                success(response) {
                    self.item = response
                    self.loader = false
                    self.update()
                },
                error() {

                }
            })

        })



| import 'components/datetime-picker.tag'
| import 'pages/settings/delivery/delivery-list-modal.tag'
| import 'pages/payments/payments-list-modal.tag'
| import 'components/loader.tag'

order-edit
    loader(if='{ loader }')
    virtual(hide='{ loader }')
        .btn-group
            a.btn.btn-default(href='#orders') #[i.fa.fa-chevron-left]
            button.btn.btn-default(if='{ isNew ? checkPermission("orders", "0100") : checkPermission("orders", "0010") }',
            onclick='{ submit }', type='button')
                i.fa.fa-floppy-o
                |  Сохранить
            button.btn.btn-default(if='{ !isNew }', onclick='{ reload }', title='Обновить', type='button')
                i.fa.fa-refresh
        .h4 { isNew ? 'Новый заказ' : 'Редактирование заказа № ' + item.id }

        ul.nav.nav-tabs.m-b-2
            li.active #[a(data-toggle='tab', href='#order-edit-home') Основная информация]
            li #[a(data-toggle='tab', href='#order-edit-delivery') Доставка]
            li(if='{ !isNew }') #[a(data-toggle='tab', href='#order-edit-pay') Платежи заказа]
            li(if='{ item.customFields && item.customFields.length }')
                a(data-toggle='tab', href='#order-edit-fields') Доп. информация

        .tab-content
            #order-edit-home.tab-pane.fade.in.active
                form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
                    .row
                        .col-md-1(if='{ !isNew }')
                            .form-group
                                label.control-label Ид
                                input.form-control(name='id', value='{ item.id }', readonly)
                        .col-md-2(if='{ !isNew }')
                            .form-group
                                label.control-label Дата заказа
                                datetime-picker.form-control(name='dateOrder',
                                format='YYYY-MM-DD', value='{ item.dateOrder }', icon='glyphicon glyphicon-calendar')
                        .col-md-3
                            .form-group(class='{ has-error: (error.idAuthor || error.idCompany) }')
                                label.control-label Заказчик
                                .input-group
                                    a.input-group-addon(if='{ (item.idAuthor || item.idCompany) }',
                                    href='{item.idAuthor ? "#persons/" + item.idAuthor : "#persons/companies/" + item.idCompany }', target='_blank')
                                        i.fa.fa-eye
                                    input.form-control(name='idAuthor',
                                    value='{ (item.idAuthor || item.idCompany) ? (item.idAuthor || item.idCompany) + " - " + item.customer : "" }', readonly)
                                    span.input-group-addon(onclick='{ changeCustomer }')
                                        i.fa.fa-list
                                .help-block { (error.idAuthor || error.idCompany) }
                        .col-md-3
                            .form-group
                                label.control-label Статус заказа
                                select.form-control(name='status')
                                    option(each='{ key, value in orderItems }', value='{ key }',
                                    selected='{ key == item.status }', no-reorder) { value }
                        .col-md-3
                            .form-group
                                label.control-label Статус доставки
                                select.form-control(name='deliveryStatus')
                                    option(each='{ key, value in deliveryItems }', value='{ key }',
                                    selected='{ key == item.deliveryStatus }', no-reorder) { value }
                    .row
                        .col-md-12
                            .well.well-sm
                                catalog-static(name='items', rows='{ item.items }', cols='{ itemsCols }',
                                handlers='{ itemsHandlers }')
                                    #{'yield'}(to='toolbar')
                                        .form-group
                                            button.btn.btn-primary(type='button', onclick='{ opts.handlers.addProducts }')
                                                i.fa.fa-plus
                                                |  Добавить товар
                                    #{'yield'}(to='body')
                                        datatable-cell(name='article') { row.article }
                                        datatable-cell(name='name') { row.name }
                                        datatable-cell(name='count')
                                            input(value='{ row.count }', type='number', step='1', min='1',
                                            onchange='{ handlers.numberChange }')
                                        datatable-cell(name='price')
                                            input(value='{ row.price }', type='number', step='0.01', min='0',
                                            onchange='{ handlers.numberChange }')
                                        datatable-cell(name='discount')
                                            input(value='{ row.discount }', type='number', step='0.01', min='0',
                                            onchange='{ handlers.numberChange }')
                                        datatable-cell(name='sum') { (row.count * row.price - row.discount).toFixed(2) }
                                .alert.alert-danger(if='{ error.items }')
                                    | { error.items }

                    .row
                        .col-md-12
                            .form-group
                                label.control-label Комментарий к заказу
                                input.form-control(name='commentary', value='{ item.commentary }')

                    .row
                        .col-md-12
                            .h4 Суммы
                            .row
                                .col-md-3
                                    .form-group
                                        label.control-label Товаров и услуг
                                        input.form-control(value='{ sumProducts.toFixed(2) }', readonly)
                                .col-md-3
                                    .form-group
                                        label.control-label Доставка
                                        input.form-control(name='deliveryPayee', type='number',
                                        value='{ (item.deliveryPayee / 1).toFixed(2) }', min='0.00', step='0.01')
                                .col-md-3
                                    .form-group
                                        label.control-label Скидка
                                        input.form-control(name='discount', type='number',
                                        value='{ (item.discount / 1).toFixed(2) }', min='0.00', step='0.01')
                                .col-md-3
                                    .form-group.has-success
                                        label.control-label Итого
                                        input.form-control(value='{ (total / 1).toFixed(2) }', step='0.01', readonly)

            #order-edit-delivery.tab-pane.fade
                form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label Доставка
                                .input-group
                                    input.form-control(name='deliveryName', value='{ item.deliveryName }', readonly)
                                    span.input-group-addon(onclick='{ changeDelivery }')
                                        i.fa.fa-list
                        .col-md-6
                            .form-group
                                label.control-label Почтовый индекс
                                input.form-control(name='postindex', value='{ item.postindex }')
                        .col-md-12
                            .form-group
                                label.control-label Адрес
                                input.form-control(name='address', value='{ item.address }')
                        .col-md-6
                            .form-group
                                label.control-label E-mail
                                input.form-control(name='email', value='{ item.email }')
                        .col-md-6
                            .form-group
                                label.control-label Телефон
                                input.form-control(name='telnumber', value='{ item.telnumber }')
                        .col-md-6
                            .form-group
                                label.control-label Время звонка
                                input.form-control(name='calltime', value='{ item.calltime }')
                        .col-md-6
                            .form-group
                                label.control-label Дата доставки
                                datetime-picker.form-control(name='deliveryDate', format='YYYY-MM-DD', value='{ item.deliveryDate }')
            #order-edit-pay.tab-pane.fade(if='{ !isNew }')
                form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
                    .row
                        .col-md-12
                            catalog-static(name='payments', rows='{ item.payments }', cols='{ paymentsCols }' )
                                #{'yield'}(to='body')
                                    datatable-cell(name='id') { row.id }
                                    datatable-cell(name='num') { row.num }
                                    datatable-cell(name='date') { row.date }
                                    datatable-cell(name='name') { row.name }
                                    datatable-cell(name='payer') { row.payer }
                                    datatable-cell(name='amount') { row.amount }
                                    datatable-cell(name='note') { row.note }
            #order-edit-fields.tab-pane.fade(if='{ item.customFields && item.customFields.length }')
                add-fields-edit-block(name='customFields', value='{ item.customFields }')


    script(type='text/babel').
        var self = this,
            route = riot.route.create()


        self.isNew = false
        self.item = {}
        self.loader = false
        self.sumProducts = 0
        self.total = 0

        self.mixin('validation')
        self.mixin('permissions')
        self.mixin('change')

        self.rules = () => {
            let rules = {
                items: {
                    required: true,
                    rules: [{
                        type: 'minLength[1]',
                        prompt: 'В списке должно быть не менее одного элемента'
                    }]
                },
            }

            if (self.item && self.item.idAuthor && self.item.idCompany)
                return { ...rules }
            else
                return { ...rules, idAuthor: 'empty' }
        }

        self.afterChange = e => {
            let name = e.target.name
            delete self.error[name]
            self.error = {...self.error, ...self.validation.validate(self.item, self.rules(), name)}
        }

        self.dynFieldsChange = e => {
            let type = e.item.field.type

            if (type !== 'checkbox') {
                e.item.field.value = e.target.value
            } else {
                let checkedValues = (e.item.field.value || '').split(',')
                let checkedValue = e.target.getAttribute('data-value')
                let idx = checkedValues.indexOf(checkedValue)

                if (idx !== -1)
                    checkedValues.splice(idx, 1)
                else
                    checkedValues.push(checkedValue)

                e.item.field.value = checkedValues.filter(i => i).join(',')
            }
        }

        self.itemsCols = [
            {name: 'article', value: 'Артикул'},
            {name: 'name', value: 'Наименование'},
            {name: 'count', value: 'Кол-во'},
            {name: 'price', value: 'Цена'},
            {name: 'discount', value: 'Скидка'},
            {name: 'summ', value: 'Стоимость'},
        ]

        self.paymentsCols = [
            {name: 'id', value: '#'},
            {name: 'num', value: '№'},
            {name: 'date', value: 'Дата'},
            {name: 'name', value: 'Наименование'},
            {name: 'payer', value: 'Плательщик'},
            {name: 'amount', value: 'Сумма'},
            {name: 'note', value: 'Примечание'},
        ]

        self.itemsHandlers = {
            numberChange(e) {
                this.row[this.opts.name] = e.target.value
            },
            addProducts() {
                modals.create('products-list-select-modal', {
                    type: 'modal-primary',
                    size: 'modal-lg',
                    submit() {
                        let _this = this
                        let items = _this.tags.catalog.tags.datatable.getSelectedRows()
                        self.item.items = self.item.items || []

                        if (items.length > 0) {
                            if ('countModifications' in items[0] &&
                                items[0].countModifications > 0) {
                                modals.create('modifications-list-modal', {
                                    type: 'modal-primary',
                                    size: 'modal-lg',
                                    id: items[0].id,
                                    submit() {
                                        let items = this.tags['catalog-static'].tags.datatable.getSelectedRows()
                                        items.forEach(item => {
                                            self.item.items.push({...item, count: 1, discount: 0, id: null, idPrice: item.id})
                                        })
                                        self.update()
                                        this.modalHide()
                                        _this.modalHide()

                                        let event = document.createEvent('Event')
                                        event.initEvent('change', true, true)
                                        self.tags.items.root.dispatchEvent(event)
                                    }
                                })
                            } else {
                                let ids = self.item.items.map(item => item.id)

                                items.forEach(item => {
                                    if (ids.indexOf(item.id) === -1)
                                        self.item.items.push({...item, count: 1, discount: 0, id: null, idPrice: item.id})
                                })

                                self.update()
                                _this.modalHide()

                                let event = document.createEvent('Event')
                                event.initEvent('change', true, true)
                                self.tags.items.root.dispatchEvent(event)
                            }
                        }
                    }
                })
            }
        }

        self.orderItems = {
            Y: 'Оплачен', N: 'Не оплачен', K: 'Кредит', P: 'Подарок', W: 'В ожидании', C: 'Возврат', T: 'Тест'
        }

        self.deliveryItems = {
            Y: 'Доставлен', N: 'Не доставлен', M: 'В работе', P: 'Отправлен'
        }

        self.changeDelivery = () => {
            modals.create('delivery-list-modal', {
                type: 'modal-primary',
                size: 'modal-lg',
                submit() {
                    let items = this.tags.catalog.tags.datatable.getSelectedRows()
                    self.item.deliveryName = items[0].name
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.changeCustomer = () => {
            modals.create('persons-company-list-modal',{
                type: 'modal-primary',
                size: 'modal-lg',
                submit() {
                    let items = this.tags[this.tab].tags.datatable.getSelectedRows()
                    if (!items.length) return

                    if (this.tab == 'contacts') {
                        self.item.idAuthor = items[0].id
                        self.item.customer = items[0].displayName
                        self.item.idCompany = null
                    } else {
                        self.item.idCompany = items[0].id
                        self.item.customer = items[0].name
                        self.item.idAuthor = null
                    }

                    self.update()
                    this.modalHide()
                }
            })
        }

        self.addPayment = () => {
            modals.create('payments-list-modal', {
                type: 'modal-primary',
                size: 'modal-lg',
                submit() {
                    self.item.payments = self.item.payments || []

                    let items = this.tags.catalog.tags.datatable.getSelectedRows()

                    let ids = self.item.payments.map(item => {
                        return item.id
                    })

                    items.forEach(function (item) {
                        if (ids.indexOf(item.id) === -1) {
                            self.item.payments.push(item)
                        }
                    })

                    self.update()
                    this.modalHide()
                }
            })

        }

        self.submit = e => {
            var params = self.item
            self.error = self.validation.validate(self.item, self.rules())

            if (!self.error) {
                API.request({
                    object: 'Order',
                    method: 'Save',
                    data: params,
                    success(response) {
                        self.item = response
                        self.isNew = false
                        self.update()
                        if (self.isNew)
                            riot.route(`/orders/${self.item.id}`)
                        popups.create({title: 'Успех!', text: 'Заказ сохранен!', style: 'popup-success'})
                        observable.trigger('orders-reload')
                    }
                })
            }
        }

        self.reload = e => {
            observable.trigger('orders-edit', self.item.id)
        }

        self.on('update', () => {
            if (self.item && self.item.items) {
                self.sumProducts = self.item.items.map(i => i.count * i.price - i.discount).reduce((p, c) => p + c, 0)
                if (parseFloat(self.sumProducts) > 0)
                    self.total = parseFloat(self.sumProducts || 0) + parseFloat(self.item.deliveryPayee || 0) - parseFloat(self.item.discount || 0)
                else
                    self.total = 0
            }
        })

        observable.on('order-new', () => {
            self.error = false
            self.isNew = true
            self.item = { deliveryPayee: 0, discount: 0, statusOrder: 'N', statusDelivery: 'N' }
            self.update()
        })


        observable.on('orders-edit', id => {
            var params = {id}
            self.error = false
            self.isNew = false
            self.item = {}
            self.loader = true
            self.update()

            API.request({
                object: 'Order',
                method: 'Info',
                data: params,
                success(response) {
                    self.item = response
                    self.loader = false
                    self.update()
                }
            })
        })

        self.on('mount', () => {
            riot.route.exec()
        })
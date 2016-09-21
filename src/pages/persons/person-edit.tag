| import 'components/ckeditor.tag'
| import 'components/loader.tag'
| import 'pages/persons/persons-category-select-modal.tag'
| import 'pages/persons/person-balance-modal.tag'
| import 'pages/persons/persons-list-select-modal.tag'
| import md5 from 'blueimp-md5/js/md5.min.js'

person-edit
    loader(if='{ loader }')
    virtual(hide='{ loader }')
        .btn-group
            a.btn.btn-default(href='#persons') #[i.fa.fa-chevron-left]
            button.btn.btn-default(if='{ checkPermission("contacts", "0010") }', onclick='{ submit }', type='button')
                i.fa.fa-floppy-o
                |  Сохранить
            button.btn.btn-default(onclick='{ reload }', title='Обновить', type='button')
                i.fa.fa-refresh
        .h4 { ['Редактирование контакта:', "[#" + item.id + "]", item.lastName, item.firstName, item.secondName].join(" ") }

        ul.nav.nav-tabs.m-b-2
            li.active #[a(data-toggle='tab', href='#person-edit-home') Информация]
            //li #[a(data-toggle='tab', href='#person-edit-documents') Паспортные данные]
            //li #[a(data-toggle='tab', href='#person-edit-requisites') Реквизиты компании]
            //li(if='{ checkPermission("orders", "1000") }') #[a(data-toggle='tab', href='#person-edit-orders') Заказы]
            li(if='{ checkPermission("products", "1000") }') #[a(data-toggle='tab', href='#person-edit-groups') Группы]
            //li #[a(data-toggle='tab', href='#person-edit-balance') Лицевой счёт]
            li(if='{ item.customFields && item.customFields.length }')
                a(data-toggle='tab', href='#person-edit-fields') Доп. информация

        form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
            .tab-content
                #person-edit-home.tab-pane.fade.in.active
                    .row
                        .col-md-2
                            .form-group
                                .well.well-sm
                                    image-select(name='imageFile', section='contacts', alt='0', size='256', value='{ item.imageFile }')
                        .col-md-10
                            .row
                                .col-md-4
                                    .form-group
                                        label.control-label Фамилия
                                        input.form-control(name='lastName', type='text', value='{ item.lastName }')
                                .col-md-4
                                    .form-group(class='{ has-error: error.firstName }')
                                        label.control-label Имя*
                                        input.form-control(name='firstName', type='text', value='{ item.firstName }')
                                        .help-block { error.firstName }
                                .col-md-4
                                    .form-group
                                        label.control-label Отчество
                                        input.form-control(name='patronymic', type='text', value='{ item.patronymic }')
                            .row
                                .col-md-2
                                    .form-group
                                        label.control-label Дата рождения
                                        datetime-picker.form-control(name='birthDate', format='YYYY-MM-DD', value='{ item.birthDate }')
                                .col-md-2
                                    .form-group
                                        label.control-label Пол
                                        select.form-control(name='sex', value='{ item.sex }')
                                            option(value='N') Не указан
                                            option(value='M') Мужской
                                            option(value='F') Женский
                                .col-md-4
                                    .form-group
                                        label.control-label Телефон
                                        input.form-control(name='phone', type='text', value='{ item.phone }')
                                .col-md-4
                                    .form-group(class='{ has-error: error.email }')
                                        label.control-label Email
                                        input.form-control(name='email', type='text', value='{ item.email }')
                                        .help-block { error.email }
                            .row
                                .col-md-12
                                    .form-group
                                        label.control-label Адрес
                                        input.form-control(name='addr', type='text', value='{ item.addr }')
                            .row
                                .col-md-6
                                    .form-group
                                        label.control-label Логин
                                        input.form-control(name='login', type='text', value='{ item.login }')
                                .col-md-6
                                    .form-group
                                        label.control-label Пароль
                                        input.form-control(name='password', type='password', value='{ item.password }')
                    .row
                        .col-md-12
                            .form-group
                                label.control-label Примечание по контакту
                                textarea.form-control(rows='5', name='note',
                                style='min-width: 100%; max-width: 100%;', value='{ item.note }')
                    .row
                        .col-md-12
                            .checkbox
                                label
                                    input(type='checkbox', name='isActive', checked='{ item.isActive == 1 }')
                                    | Активен
                    .row
                        .col-md-12
                            .form-group
                                label Зарегистрирован:
                                    nbsp
                                    b { item.regDate }

                //#person-edit-orders.tab-pane.fade(if='{ checkPermission("orders", "1000") }')
                    .row
                        .col-md-12
                            datatable(cols='{ cols }', rows='{ orders }', handlers='{ handlersOrders }', dblclick='{ dblclickOrder }')
                                datatable-cell(name='id') {row.id}
                                datatable-cell(name='dateOrder') {row.dateOrder}
                                datatable-cell(name='amount') {row.amount}
                                datatable-cell(name='status', class='{ handlers.orderText.colors[row.status] }')
                                    | { handlers.orderText.text[row.status] }
                                datatable-cell(name='deliveryStatus', class='{ handlers.deliveryText.colors[row.deliveryStatus] }')
                                    | { handlers.deliveryText.text[row.deliveryStatus] }
                                datatable-cell(name='note') { row.note }

                #person-edit-groups.tab-pane.fade(if='{ checkPermission("products", "1000") }')
                    .row.m-b-3
                        .col-md-12
                            .form-inline
                                .form-group
                                    button.btn.btn-primary(onclick='{ addGroup }', type='button')
                                        i.fa.fa-plus
                                        |  Добавить
                                .form-group
                                    button.btn.btn-danger(if='{ groupsSelectedCount }', onclick='{ removeGroups }', title='Удалить', type='button')
                                        i.fa.fa-trash { (groupsSelectedCount > 1) ? "&nbsp;" : "" }
                                        span.badge(if='{ groupsSelectedCount > 1 }') { groupsSelectedCount }

                    .row
                        .col-md-12
                            datatable(name='groups', cols='{ groupsCols }', rows='{ item.groups }')
                                datatable-cell(name='id') { row.id }
                                datatable-cell(name='name') { row.name }

                //#person-edit-balance.tab-pane.fade
                    .row
                        .col-md-12
                            catalog-static(name='personalAccount', add='{ addBalance }', dblclick='{ editBalance }',
                                after-remove='{ recalcBalance }', cols='{ balanceCols }', rows='{ item.personalAccount }')
                                #{'yield'}(to='body')
                                    datatable-cell(name='datePayee') { row.datePayee }
                                    datatable-cell(name='inPayee') { (row.inPayee / 1).toFixed(2) }
                                    datatable-cell(name='outPayee') { (row.outPayee / 1).toFixed(2) }
                                    datatable-cell(name='balance') { (row.balance / 1).toFixed(2) }
                                    datatable-cell(name='docum') { row.docum }
                #person-edit-fields.tab-pane.fade(if='{ item.customFields && item.customFields.length }')
                    add-fields-edit-block(name='customFields', value='{ item.customFields }')

    script(type='text/babel').
        var self = this

        self.item = {}
        self.orders = []
        self.groupsSelectedCount = 0
        self.accountOperations = []

        self.mixin('permissions')
        self.mixin('validation')
        self.mixin('change')

        self.rules = {
            firstName: 'empty',
            email: {rules: [{type: 'email'}]}
        }

        self.afterChange = e => {
            let name = e.target.name
            delete self.error[name]
            self.error = {...self.error, ...self.validation.validate(self.item, self.rules, name)}
        }

        self.cols = [
            { name: 'id' , value: '#' },
            { name: 'dateOrder' , value: 'Дата заказа' },
            { name: 'amount' , value: 'Сумма' },
            { name: 'status' , value: 'Статус заказа' },
            { name: 'deliveryStatus' , value: 'Статус доставки' },
            { name: 'note' , value: 'Примечание' }
        ]

        self.groupsCols = [
            {name: 'id', value: '#'},
            {name: 'name', value: 'Наименование'}
        ]

        self.balanceCols = [
            {name: 'datePayee', value: 'Дата'},
            {name: 'inPayee', value: 'Приход'},
            {name: 'outPayee', value: 'Расход'},
            {name: 'balance', value: 'Баланс'},
            {name: 'docum', value: 'Примечание'}
        ]

        self.companyRequisitesHandlers = {
            valueChange(e) {
                var selectionStart = e.target.selectionStart
                var selectionEnd = e.target.selectionEnd
                this.row.value = e.target.value

                this.update()
                e.target.selectionStart = selectionStart
                e.target.selectionEnd = selectionEnd
            }
        }

        self.addGroup = () => {
            modals.create('persons-category-select-modal', {
                type: 'modal-primary',
                submit() {
                    self.item.groups = self.item.groups || []
                    let items = this.tags.catalog.tags.datatable.getSelectedRows()

                    let ids = self.item.groups.map(item => {
                        return item.id
                    })

                    items.forEach(item => {
                        if (ids.indexOf(item.id) === -1) {
                            self.item.groups.push(item)
                        }
                    })

                    self.update()
                    this.modalHide()
                }
            })
        }

        self.recalcBalance = () => {
            let balance = 0.0
            self.item.personalAccount.forEach(function(item) {
                balance += parseFloat(item.inPayee) - parseFloat(item.outPayee)
                item.balance = parseFloat(balance)
            })
        }

        self.addBalance = () => {
            modals.create('person-balance-modal', {
                type: 'modal-primary',
                typeOperations: self.accountOperations,
                submit() {
                    self.item.personalAccount.push(this.item)
                    self.recalcBalance()
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.editBalance = (e) => {
            modals.create('person-balance-modal', {
                type: 'modal-primary',
                typeOperations: self.accountOperations,
                item: e.item.row,
                submit() {
                    self.recalcBalance()
                    self.update()
                    this.modalHide()
                }
            })
        }

        self.removeGroups = e => {
            self.groupsSelectedCount = 0
            self.item.groups = self.tags.groups.getUnselectedRows()
            self.update()
        }

        self.submit = e => {
            var params = self.item
            self.error = self.validation.validate(params, self.rules)

            if (!self.error) {
                if (self.item && self.item.password && self.item.password.trim() === '')
                    delete self.item.password
                else
                    self.item.password = md5(self.item.password)

                API.request({
                    object: 'Contact',
                    method: 'Save',
                    data: params,
                    success(response) {
                        popups.create({title: 'Успех!', text: 'Контакт сохранен!', style: 'popup-success'})
                        self.item = response
                        self.item.password = new Array(8).join(' ')
                        self.update()
                        observable.trigger('persons-reload')
                    }
                })
            }
        }

        self.reload = () => {
            observable.trigger('persons-edit', self.item.id)
        }

        observable.on('persons-edit', id => {
            var params = {id: id}
            self.error = false
            self.loader = true
            API.request({
                object: 'Contact',
                method: 'Info',
                data: params,
                success: (response, xhr) => {
                    self.item = response
                    self.item.password = new Array(8).join(' ')
                    self.accountOperations = response.accountOperations
                    self.loader = false
                    self.update()
                },
                error(response) {
                    self.item = {}
                    self.loader = false
                    self.update()
                }
             })

        })

        //        self.changeReferContact = () => {
        //            modals.create('persons-list-select-modal',{
        //                type: 'modal-primary',
        //                size: 'modal-lg',
        //                submit() {
        //                    let items = this.tags.catalog.tags.datatable.getSelectedRows()
        //                    if (!items.length) return
        //
        //                    self.item.idUp = items[0].id
        //                    self.item.referName = items[0].displayName
        //
        //                    self.update()
        //                    this.modalHide()
        //                }
        //            })
        //        }
        //
        //        self.removeReferContact = () => {
        //            self.item.idUp = null
        //            self.item.referName = null
        //        }

        self.one('updated', () => {
            self.tags.groups.on('row-selected', count => {
                self.groupsSelectedCount = count
                self.update()
            })
        })

        //        self.orderText = {
        //             text: {
        //                Y: 'Оплачен', N: 'Не оплачен', K: 'Кредит', P: 'Подарок', W: 'В ожидании', C: 'Возврат', T: 'Тест'
        //             },
        //             colors: {
        //                Y: 'bg-success', N: 'bg-danger', K: 'bg-warning', P: null, W: null, C: null, T: null
        //             }
        //        }
        //
        //        self.deliveryText = {
        //            text: {
        //                Y: 'Доставлен', N: 'Не доставлен', M: 'В работе', P: 'Отправлен'
        //            },
        //            colors: {
        //                Y: 'bg-success', N: 'bg-danger', M: null, P: null
        //            }
        //        }

        self.handlersOrders = {
            orderText: self.orderText,
            deliveryText: self.deliveryText
        }

        self.dblclickOrder = e => {
            riot.route(`/orders/${e.item.row.id}`)
        }

        self.on('mount', () => {
            riot.route.exec()
        })
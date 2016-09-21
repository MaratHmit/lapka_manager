| import 'components/catalog.tag'
| import 'pages/persons/person-new-modal.tag'

persons-list

    catalog(search='true', sortable='true', object='Contact', cols='{ cols }', reload='true',
    add='{ permission(add, "contacts", "0100") }',
    remove='{ permission(remove, "contacts", "0001") }',
    dblclick='{ permission(personOpen, "contacts", "1000") }', store='persons-list')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='regDate') { row.regDate }
            datatable-cell(name='displayName') { row.displayName }
            datatable-cell(name='username') { row.username }
            datatable-cell(name='email') { row.email }
            datatable-cell(name='phone') { row.phone }
            datatable-cell(name='countOrders') { row.countOrders }
            datatable-cell(name='amountOrders') { (row.amountOrders / 1).toFixed(2) }/{ (row.paidOrders / 1).toFixed(2) }
        #{'yield'}(to='filters')
            .well.well-sm
                .form-inline
                    .form-group
                        label.control-label Группа
                        select.form-control(data-name='idGroup', data-sign='IN')
                            option(value='') Все
                            option(each='{ category, i in parent.categories }', value='{ category.id }', no-reorder) { category.name }


    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Contact'

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'regDate', value: 'Время рег.'},
            {name: 'displayName', value: 'Ф.И.О'},
            {name: 'username', value: 'Логин'},
            {name: 'email', value: 'E-mail'},
            {name: 'phone', value: 'Телефоны'},
            {name: 'countOrders', value: 'Кол-во зак.'},
            {name: 'amountOrders', value: 'Сумма/оплач. зак.'},
        ]

        self.add = function () {
            modals.create('person-new-modal', {
                type: 'modal-primary',
                submit() {
                    var _this = this
                    var params = { firstName: _this.name.value }
                    API.request({
                        object: 'Contact',
                        method: 'Save',
                        data: params,
                        success(response, xhr) {
                            popups.create({title: 'Успех!', text: 'Контакт добавлен!', style: 'popup-success'})
                            _this.modalHide()
                            self.tags.catalog.reload()
                            if (response && response.id)
                                self.personOpenItem(response.id)
                        }
                    })
                }
            })
        }

        self.personOpen = e => {
            riot.route(`/persons/${e.item.row.id}`)
        }

        self.personOpenItem = id => {
            riot.route(`/persons/${id}`)
        }

        self.getContactCategory = () => {
            API.request({
                object: 'ContactCategory',
                method: 'Fetch',
                success(response) {
                    self.categories = response.items
                    self.update()
                }
            })
        }

        self.one('updated', () => {
            self.tags.catalog.on('reload', () => {
                self.getContactCategory()
            })
        })

        self.getContactCategory()

        observable.on('persons-reload', () => self.tags.catalog.reload())
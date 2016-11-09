| import 'components/catalog.tag'
| import './pets-edit-modal.tag'

pets-list

    catalog(search='true', sortable='true', object='Pet', cols='{ cols }', reload='true', store='pats-list',
        add='{ permission(addEdit, "products", "0100") }',
        remove='{ permission(remove, "products", "0001") }',
        dblclick='{ permission(addEdit, "products", "1000") }')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='name') { row.name }

    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Pet'

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'name', value: 'Наименование' },
        ]

        self.addEdit = e => {
            let id
            if (e && e.item && e.item.row)
            id = e.item.row.id

            modals.create('pets-edit-modal', {
                type: 'modal-primary',
                id,
                submit() {
                    let _this = this

                    _this.error = _this.validation.validate(_this.item, _this.rules)

                    if (!_this.error) {
                        API.request({
                            object: 'Pet',
                            method: 'Save',
                            data: _this.item,
                            success(response) {
                                popups.create({title: 'Успех!', text: 'Информация сохранена!', style: 'popup-success'})
                                    observable.trigger('pets-reload')
                                    if (!id)
                                    _this.modalHide()
                                },
                            })
                    }
                }
            })
        }

        observable.on('pets-reload', () => {
            self.tags.catalog.reload()
        })
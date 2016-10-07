product-edit-modifications
    .row
        .col-md-12
            catalog-static(name='{ opts.name }', cols='{ cols }', rows='{ value }', handlers='{ handlers }',
            add='{ opts.add }')
                #{'yield'}(to='body')
                    datatable-cell(name='id') { row.id }
                    datatable-cell(name='article')
                        input(name='article', value='{ row.article }', onchange='{ handlers.change }')
                    datatable-cell(name='price')
                        input(name='price', type='number', min='0', step='0.01', value='{ row.price }', onchange='{ handlers.change }')
                    datatable-cell(name='count')
                        input(name='count', type='number', min='0', step='1', value='{ row.count }', onchange='{ handlers.change }')
                    datatable-cell(each='{ item, i in parent.parent.parent.newCols }', name='{ item.name }') { row.params[i].value }


    script(type='text/babel').
        let self = this

        self.value = opts.value || []
        self.cols = []
        self.newCols = []

        self.handlers = {
            change(e) {
                if (!e.target.name) return

                var bannedTypes = ['checkbox', 'file', 'color', 'range', 'number']

                if (e.target && bannedTypes.indexOf(e.target.type) === -1) {
                    var selectionStart = e.target.selectionStart
                    var selectionEnd = e.target.selectionEnd
                }

                if (e.target && e.target.type === 'checkbox' && e.target.name)
                    e.item.row[e.target.name] = e.target.checked
                if (e.target && e.target.type !== 'checkbox' && e.target.name)
                    e.item.row[e.target.name] = e.target.value
                if (e.currentTarget.tagName !== 'FORM' && e.currentTarget.name !== '')
                    e.item.row[e.currentTarget.name] = e.currentTarget.value

                if (e.target && bannedTypes.indexOf(e.target.type) === -1) {
                    this.update()
                    e.target.selectionStart = selectionStart
                    e.target.selectionEnd = selectionEnd
                }
            }
        }

        self.on('update', () => {
            self.value = opts.value || []

            self.initCols = [
                {name: 'id', value: '#'},
                {name: 'article', value: 'Артикул'},
                {name: 'price', value: 'Цена'},
                {name: 'count', value: 'Кол-во'},
            ]

            if (opts.isUnlimited) {
                self.initCols[3].hidden = true
            }

            self.root.name = opts.name || ''
            self.newCols = []

            if (self.value.length &&
                self.value[0].params &&
                self.value[0].params instanceof Array) {
                self.newCols = self.value[0].params.map((item, i) => {
                    return { name: i, value: item.name }
                })
            }

            self.cols = [...self.initCols, ...self.newCols]
        })

product-edit-modifications-add-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title Модификация
        #{'yield'}(to="body")
            form(onchange='{ change }')
                .form-group(each='{ item, i in features }')
                    label.control-label { item.name }
                    select.form-control(name='{ item.id }', value='{ item.value }')
                        option(each='{ values, i in item.values }', value='{ values.id }') { values.value }
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') Выбрать

    script(type='text/babel').
        var self = this

        self.on('mount', () => {
            let modal = self.tags['bs-modal']
            //modal.mixin('change')
            modal.item = {}

            modal.change = e => {
                let id = e.target.name
                let item = modal.item.filter(i => i.idFeature == id)
                let originalItem = modal.features.filter(i => i.id == id)

                if (!item.length) return
                if (!originalItem.length) return

                item[0].idValue = e.target.value
                item[0].value = originalItem[0].values.filter(i => i.id == e.target.value)[0].value
            }

            API.request({
                object: 'ProductType',
                method: 'Info',
                data: {id: opts.idType},
                success(response) {
                    modal.features = response.features.filter(i => i.target == 1)
                    modal.item = modal.features.map(item => {
                        let newItem = {
                            idFeature: item.id,
                            name: item.name,
                            idValue: null,
                            value: null
                        }

                        return {...newItem}
                    })
                    self.update()
                },

            })
        })

modifications-list-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title Модификации товара
        #{'yield'}(to="body")
            catalog-static(cols='{ parent.cols }', rows='{ parent.rows }')
                #{'yield'}(to='body')
                    datatable-cell(name='name') { row.name }
                    datatable-cell(name='count') { row.count }
                    datatable-cell(name='price') { row.price }
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') Сохранить

    script(type='text/babel').
        var self = this
        self.rows = []

        self.cols = [
            {name: 'name', value: 'Наименование'},
            {name: 'count', value: 'Кол-во'},
            {name: 'price', value: 'Цена'},
        ]

        self.on('update', () => {

        })

        self.on('mount', () => {
            self.loader = true
            API.request({
                object: 'Products',
                method: 'Info',
                data: {ids: [opts.id]},
                notFoundRedirect: false,
                success(response) {
                    let name = response.items[0].name
                    let modifications = response.items[0].modifications

                    self.rows = []

                    if (modifications.length > 0) {
                        modifications.forEach(item => {
                            let _item = item
                            let count = item.columns.length
                            let names = item.columns.map(i => i.name)

                            if ('items' in item &&
                                item.items instanceof Array &&
                                item.items.length > 0) {

                                item.items.forEach(item => {
                                    let namesValues = item.values.map(i => i.name)
                                    let row = names.map((item, i) => `${item}: ${namesValues[i]}`)
                                    let value = `${name} (${row.join(', ')})`
                                    self.rows.push({...item, id: _item.id, name: value})
                                })
                            }
                        })
                    }
                    self.loader = false
                    self.update()
                }
            })
        })
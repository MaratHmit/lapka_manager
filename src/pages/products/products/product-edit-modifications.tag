product-edit-modifications
    .row
        .col-md-12
            catalog-static(name='{ opts.name }', cols='{ cols }', rows='{ value }', handless='{ handlers }')
                #{'yield'}(to='body')
                    datatable-cell(name='id') { row.id }
                    datatable-cell(name='article')
                        input(name='article', value='{ row.article }', onchange='{ handlers.change }')
                    datatable-cell(name='price')
                        input(name='price', type='number', min='0', step='0.01', value='{ row.price }', onchange='{ handlers.change }')
                    datatable-cell(name='count')
                        input(name='count', type='number', min='1', step='1', value='{ row.count }', onchange='{ handlers.change }')
                    datatable-cell(each='{ item, i in parent.parent.parent.newCols }', name='{ item.name }') { row.params[i].value }


    script(type='text/babel').
        let self = this

        self.value = opts.value || []
        self.cols = []
        self.newCols = []

        self.initCols = [
            {name: 'id', value: '#'},
            {name: 'article', value: 'Артикул'},
            {name: 'price', value: 'Цена'},
            {name: 'count', value: 'Кол-во'},
        ]

        self.on('update', () => {
            self.value = opts.value || []
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
delivery
    catalog(object='Delivery', cols='{ cols }', reload='true', handlers='{ handlers }',
        dblclick='{ permission(deliveryOpen, "deliveries", "1000") }')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='name') { row.name }
            datatable-cell(name='note') { row.note }


    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Delivery'
        self.handlers = {}

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'name', value: 'Наименование'},
            {name: 'note', value: 'Примечание'},
        ]

        self.deliveryOpen = e => riot.route(`settings/delivery/${e.item.row.id}`)

        self.on('mount', () => {
            API.request({
                object: 'Delivery',
                method: 'Fetch',
                success(response) {
                    self.handlers.types = {}
                    response.items.forEach(item => {
                        self.handlers.types[item.id] = {
                            code: item.code,
                            name: item.name
                        }
                    })
                },
                error(response) {
                    self.handlers.types = {}
                },
                complete() {
                    self.update()
                }
            })
        })

        observable.on('delivery-reload', () => {
            self.tags.catalog.reload()
        })

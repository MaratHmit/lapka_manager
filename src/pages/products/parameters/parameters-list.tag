| import 'components/catalog.tag'
| import 'pages/products/parameters/parameter-new-modal.tag'


parameters-list
    catalog(object='Feature', cols='{ cols }', search='true', reorder='true', handlers='{ handlers }', reload='true', store='parameters-list',
    add='{ permission(add, "products", "0100") }',
    remove='{ permission(remove, "products", "0001") }',
    dblclick='{ permission(parameterOpen, "products", "1000") }')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='name') { row.name }
            datatable-cell(name='measure') { row.measure }
            datatable-cell(name='type') { handlers.featureName(row.type) }
            datatable-cell(name='sort') { row.sort }
            datatable-cell(name='nameGroup') { row.nameGroup }

    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Feature'

        var getFeaturesTypes = () => {
            API.request({
                object: 'FeatureType',
                method: 'Fetch',
                data: {},
                success(response) {
                    self.featuresTypes = response.items
                    self.update()
                }
            })
        }

        var featureName = type => {
            for (var i = 0; i < self.featuresTypes.length; i++) {
                if (self.featuresTypes[i].code === type)
                    return self.featuresTypes[i].name
            }
        }

        self.add = () => {
            modals.create('parameter-new-modal', {
                type: 'modal-primary',
                submit() {
                    var _this = this
                    var params = {name: _this.name.value}
                    _this.error = _this.validation.validate(_this.item, _this.rules)

                    if (!_this.error) {
                        API.request({
                            object: 'Feature',
                            method: 'Save',
                            data: params,
                            success(response) {
                                _this.modalHide()
                                if (response.id)
                                    riot.route(`products/parameters/${response.id}`)
                            }
                        })
                    }
                }
            })
        }

        self.parameterOpen = e => riot.route(`/products/parameters/${e.item.row.id}`)

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'name', value: 'Наименование'},
            {name: 'measure', value: 'Ед. изм.'},
            {name: 'type', value: 'Тип параметра'},
            {name: 'sort', value: 'Индекс'},
            {name: 'nameGroup', value: 'Группа параметра'},
        ]

        self.handlers = {
            featureName: featureName
        }

        self.one('updated', () => {
            self.tags.catalog.tags.datatable.on('reorder-end', () => {
                let {current, limit} = self.tags.catalog.pages
                let params = { indexes: [] }
                let offset = current > 0 ? (current - 1) * limit : 0

                self.tags.catalog.items.forEach((item, sort) => {
                    item.sort = sort + offset
                    params.indexes.push({id: item.id, sort: sort + offset})
                })

                API.request({
                    object: 'Feature',
                    method: 'Sort',
                    data: params,
                    notFoundRedirect: false
                })

                self.update()
            })
        })

        observable.on('parameters-groups-reload', () => {
            self.tags.catalog.reload()
        })


        getFeaturesTypes()

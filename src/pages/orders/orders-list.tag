| import 'components/catalog.tag'

orders-list

    catalog(object='Order', search='true', sortable='true', cols='{ cols }', handlers='{ handlers }', reload='true',
    remove='{ permission(remove, "orders", "0001") }',
    dblclick='{ permission(orderOpen, "orders", "1000") }',
    before-success='{ getAggregation }',store='orders-list', new-filter='true')
        #{'yield'}(to='filters')
            .well.well-sm
                .form-inline
                    .form-group
                        label.control-label От даты
                        datetime-picker.form-control(data-name='dateOrder', data-sign='>=', format='YYYY-MM-DD')
                    .form-group
                        label.control-label До даты
                        datetime-picker.form-control(data-name='dateOrder', data-sign='<=', format='YYYY-MM-DD')
                    .form-group
                        label.control-label Статус заказа
                        select.form-control(data-name='status')
                            option(value='') Все
                            option(value='Y') Оплачен
                            option(value='N') Не оплачен
                            option(value='K') Кредит
                            option(value='P') Подарок
                            option(value='W') В ожидании
                            option(value='C') Возврат
                            option(value='T') Тест

        #{'yield'}(to="body")
            datatable-cell(name='num') { row.num }
            datatable-cell(name='date') { row.date }
            datatable-cell(name='customer') { row.customer }
            datatable-cell(name='customerPhone') { row.customerPhone }
            datatable-cell(name='amount') { row.amount }
            datatable-cell(name='status', style='{ getColorStatus(row.idStatus} ')
                | Завершенный
        #{'yield'}(to='aggregation')
            strong Сумма заказов: { (parent.totalAmount || 0) +  " " }

    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Order'
        self.statuses = []

        self.cols = [
            { name: 'num' , value: '№' },
            { name: 'dateOrder' , value: 'Дата заказа' },
            { name: 'customer' , value: 'Заказчик' },
            { name: 'customerPhone' , value: 'Телефон' },
            { name: 'amount' , value: 'Сумма' },
            { name: 'status' , value: 'Статус заказа' },
        ]

        self.orderOpen = function (e) {
            riot.route(`/orders/${e.item.row.id}`)
        }

        self.getAggregation = (response, xhr) => {
            self.totalAmount = response.totalAmount
        }

        self.add = () => riot.route('/orders/new')

        self.getStatuses = () => {
            let data = { sortBy: "id", sortOrder: "asc", limit: 1000 }
            API.request({
                object: 'OrderStatus',
                data: data,
                method: 'Fetch',
                success(response) {
                    self.statuses = response.items
                    self.update()
                }
            })
        }

        self.getColorStatus = (idStatus) => {

        }

        observable.on('orders-reload', function () {
            self.tags.catalog.reload()
        })

        self.getStatuses()




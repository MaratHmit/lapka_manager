| import 'components/catalog.tag'

orders-list

    catalog(object='Order', search='true', sortable='true', cols='{ cols }', handlers='{ handlers }', reload='true',
    add='{ permission(add, "orders", "0100") }',
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
                    .form-group
                        label.control-label Статус доставки
                        select.form-control(data-name='deliveryStatus')
                            option(value='') Все
                            option(value='Y') Доставлен
                            option(value='N') Не доставлен
                            option(value='M') В работе
                            option(value='P') Отправлен

                    .form-group
                        .checkbox-inline
                            label
                                input(type='checkbox', data-name='isDelete', data-bool='Y,N', data-required='true')
                                | Отменённые

        #{'yield'}(to="body")
            datatable-cell(name='id') { row.id }
            datatable-cell(name='dateOrder') { row.dateOrder }
            datatable-cell(name='customer') { row.customer }
            datatable-cell(name='customerPhone') { row.customerPhone }
            datatable-cell.text-right(name='amount') { row.amount }
            datatable-cell(name='status', class='{ handlers.orderText.colors[row.status] }')
                | { handlers.orderText.text[row.status] }
            datatable-cell(name='deliveryStatus', class='{ handlers.deliveryText.colors[row.deliveryStatus] }')
                | { handlers.deliveryText.text[row.deliveryStatus] }
            datatable-cell(name='namePaymentPrimary') { row.namePaymentPrimary }
            datatable-cell(name='commentary') { row.commentary }
        #{'yield'}(to='aggregation')
            strong Сумма заказов: { (parent.totalAmount || 0) +  " " }

    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')
        self.collection = 'Order'

        self.cols = [
            { name: 'id' , value: '#' },
            { name: 'dateOrder' , value: 'Дата заказа' },
            { name: 'customer' , value: 'Заказчик' },
            { name: 'customerPhone' , value: 'Телефон' },
            { name: 'amount' , value: 'Сумма' },
            { name: 'status' , value: 'Статус заказа' },
            { name: 'deliveryStatus' , value: 'Статус доставки' },
            { name: 'namePaymentPrimary' , value: 'Способ оплаты' },
            { name: 'commentary' , value: 'Примечание' },
        ]

        self.orderText = {
            text: {
                Y: 'Оплачен', N: 'Не оплачен', K: 'Кредит', P: 'Подарок', W: 'В ожидании', C: 'Возврат', T: 'Тест'
            },
            colors: {
                //Y: '#98FB98', N: '#FFC1C1', K: '#FFAAAA', P: null, W: null, C: null, T: null
                Y: 'bg-success', N: 'bg-danger', K: 'bg-warning', P: null, W: null, C: null, T: null
            }
        }

        self.deliveryText = {
            text: {
                Y: 'Доставлен', N: 'Не доставлен', M: 'В работе', P: 'Отправлен'
            },
            colors: {
                //Y: '#98FB98', N: '#FFC1C1', M: null, P: null
                Y: 'bg-success', N: 'bg-danger', M: null, P: null
            }
        }

        self.handlers = {
            orderText: self.orderText,
            deliveryText: self.deliveryText
        }

        self.orderOpen = function (e) {
            riot.route(`/orders/${e.item.row.id}`)
        }

        self.getAggregation = (response, xhr) => {
            self.totalAmount = response.totalAmount
        }

        self.add = () => riot.route('/orders/new')

        observable.on('orders-reload', function () {
            self.tags.catalog.reload()
        })




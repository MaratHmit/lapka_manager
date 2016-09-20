coupons-list
    catalog(object='Coupon', cols='{ cols }', search='true', sortable='true', handlers='{ handlers }', reload='true', store='coupons-list',
    add='{ permission(add, "products", "0100") }',
    remove='{ permission(remove, "products", "0001") }',
    dblclick='{ permission(open, "products", "1000") }')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='code') { row.code }
            datatable-cell(name='type') { handlers.typeValues[row.type] }
            datatable-cell(name='discount') { row.discount }
            datatable-cell(name='minSumOrder') { row.minSumOrder }
            datatable-cell(name='status') { row.status == 'Y' ? 'Да' : 'Нет' }
            datatable-cell(name='countUsed') { row.countUsed }
            datatable-cell(name='onlyRegistered') { row.onlyRegistered == 'Y' ? 'Да' : 'Нет' }
            datatable-cell(name='expireDate') { row.expireDate }

    script(type='text/babel').
        var self = this

        self.mixin('remove')
        self.mixin('permissions')
        self.mixin('change')
        self.collection = 'Coupon'

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'code', value: 'Код'},
            {name: 'type', value: 'Тип'},
            {name: 'discount', value: 'Скидка'},
            {name: 'minSumOrder', value: 'Мин. сумма'},
            {name: 'status', value: 'Активен'},
            {name: 'countUsed', value: 'Кол-во'},
            {name: 'onlyRegistered', value: 'Зарегистрированным'},
            {name: 'expireDate', value: 'Окончание'},
        ]

        self.add = e => riot.route(`products/coupons/new`)

        self.open = e => riot.route(`products/coupons/${e.item.row.id}`)

        self.handlers = {
            typeValues: {
                'p': 'Процент на скидку',
                'a': 'Абсолютная скидка на корзину',
                'g': 'Процент на позиции товаров',
            }
        }
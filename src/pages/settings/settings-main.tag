| import debounce from 'lodash/debounce'

| import './settings-main-preferences.tag'

settings-main
    loader(if='{ loader }')
    virtual(hide='{ loader }')
        ul.nav.nav-tabs.m-b-2
            li.active #[a(data-toggle='tab', href='#settings-main-home') Настройка магазина]
            li #[a(data-toggle='tab', href='#settings-main-company') Компания]
            li #[a(data-toggle='tab', href='#settings-main-preferences') Настройки Яндекс.Маркет]


        .tab-content
            #settings-main-home.tab-pane.fade.in.active
                form(action='', onchange='{ changeSettings }', onkeyup='{ changeSettings }', method='POST')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  Имя магазина
                                input.form-control(type='text', name='shopname' value='{ item.shopname }')
                        .col-md-6
                            .form-group
                                label.control-label  Подзаголовок
                                input.form-control(type='text', name='subname', value='{ item.subname }')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  Имя сайта
                                input.form-control(type='text', name='domain', value='{ item.domain }')
                        .col-md-6
                            .form-group
                                label.control-label  Папка магазина
                                input.form-control(type='text', name='folder', value='{ item.folder }')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  URL логотипа
                                input.form-control(type='text', name='logo', value='{ item.logo }')
                        .col-md-6
                            .form-group
                                label.control-label  Базовая валюта
                                select.form-control(name='basecurr')
                                    option(each='{ c, i in item.listCurrency }', value='{ c.name }',
                                    selected='{ c.name == parent.item.basecurr }', no-reorder) { c.title }
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  E-mail продажи
                                input.form-control(type='text', name='esales', value='{ item.esales }')
                        .col-md-6
                            .form-group
                                label.control-label  E-mail поддержки
                                input.form-control(type='text', name='esupport', value='{ item.esupport }')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label Телефоны для СМС информирования
                                input.form-control(type='text', name='smsPhone', value='{ item.smsPhone }')
                        .col-md-6
                            .form-group
                                label.control-label Отправитель СМС по умолчанию
                                input.form-control(type='text', name='smsSender', value='{ item.smsSender }')
            #settings-main-company.tab-pane.fade
                form(action='', onchange='{ changeSettings }', onkeydown='{ changeSettings }', method='POST')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  Компания
                                input.form-control(type='text', name='company', value='{ item.company }')
                        .col-md-6
                            .form-group
                                label.control-label  Руководитель (Ф.И.О)
                                input.form-control(type='text', name='director', value='{ item.director }')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  Руководитель (должность)
                                input.form-control(type='text', name='posthead', value='{ item.posthead }')
                        .col-md-6
                            .form-group
                                label.control-label  Гл. бухгалтер (Ф.И.О)
                                input.form-control(type='text', name='bookkeeper', value='{ item.bookkeeper }')
                    .row
                        .col-md-6
                            .form-group
                                label.control-label  Физический адрес
                                input.form-control(type='text', name='addrF', value='{ item.addrF }')
                        .col-md-6
                            .form-group
                                label.control-label  Юридический адрес
                                input.form-control(type='text', name='addrU', value='{ item.addrU }')
                    .row
                        .col-md-4
                            .form-group
                                label.control-label  Телефон
                                input.form-control(type='text', name='phone', value='{ item.phone }')
                        .col-md-4
                            .form-group
                                label.control-label  Факс
                                input.form-control(type='text', name='fax', value='{ item.fax }')
                        .col-md-4
                            .form-group
                                label.control-label  НДС
                                input.form-control(type='number', step='0.10', name='nds', value='{ parseFloat(item.nds) }')
            #settings-main-preferences.tab-pane.fade
                settings-main-preferences

    script(type='text/babel').
        var self = this,
            route = riot.route.create()

        self.item = {}
        self.mixin('permissions')
        self.mixin('change')

        var save = debounce(e => {
            API.request({
                object: 'Main',
                method: 'Save',
                data: self.item,
                complete: () => self.update()
            })
        }, 600)

        self.changeSettings = e => {
            if (self.checkPermission('settings', '0010')) {
                self.change(e)
                save()
            } else {
                e.target.value = self.item[e.target.getAttribute('name')]
            }
        }

        self.reload = () => {
            self.loader = true
            self.update()

            API.request({
                object: 'Main',
                method: 'Info',
                data: {},
                success(response) {
                    self.item = response
                },
                complete() {
                    self.loader = false
                    self.update()
                }
            })
        }

        route('/settings/main', () => {
            self.reload()
        })

        self.on('mount', () => {
            riot.route.exec()
        })


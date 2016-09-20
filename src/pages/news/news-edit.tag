
| import './new-categories-list-modal.tag'

news-edit
    loader(if='{ loader }')
    virtual(hide='{ loader }')
        .btn-group
            a.btn.btn-default(href='#news') #[i.fa.fa-chevron-left]
            button.btn.btn-default(if='{ isNew ? checkPermission("news", "0100") : checkPermission("news", "0010") }',
            onclick='{ submit }', type='button')
                i.fa.fa-floppy-o
                |  Сохранить
            button.btn.btn-default(if='{ !isNew }', onclick='{ reload }', title='Обновить', type='button')
                i.fa.fa-refresh
        .h4  { isNew ? item.name || 'Добавление новости' : item.name || 'Редактирование новости' }

        ul.nav.nav-tabs.m-b-2
            li.active #[a(data-toggle='tab', href='#news-edit-home') Основная информация]
            li #[a(data-toggle='tab', href='#news-edit-images') Картинки]

        form(action='', onchange='{ change }', onkeyup='{ change }', method='POST')
            .tab-content
                #news-edit-home.tab-pane.fade.in.active
                    .row
                        .col-md-2
                            .form-group
                                .well.well-sm
                                    image-select(name='imageFile', section='newsimg', alt='0', size='256', value='{ item.imageFile }')
                        .col-md-10
                            .row
                                .col-md-12
                                    .form-group(class='{ has-error: error.name }')
                                        label.control-label Заголовок
                                        input.form-control(name='name', type='text', value='{ item.name }')
                                        .help-block { error.name }
                            .row
                                .col-md-2
                                    .form-group
                                        label.control-label Дата публикации
                                        datetime-picker.form-control(name='publicationDate', format='DD.MM.YYYY', value='{ item.publicationDateDisplay }')
                                .col-md-10
                                    .form-group
                                        label.control-label Категория
                                        .input-group
                                            input.form-control(name='nameCategory', value='{ item.nameCategory }', readonly)
                                            span.input-group-addon(onclick='{ changeCategory }')
                                                i.fa.fa-list
                    .row
                        .col-md-12
                            .form-group
                                label.control-label Текст новости
                                ckeditor(name='fullDescription', value='{ item.fullDescription }')
                    .row
                        .col-md-12
                            .form-group
                                .checkbox-inline
                                    label
                                        input(type='checkbox', name='isActive', checked='{ item.isActive }')
                                        | Отображать на сайте
                #news-edit-images.tab-pane.fade
                    product-edit-images(name='images', value='{ item.images }', section='newsimg')

    script(type='text/babel').
        var self = this

        self.isNew = false

        self.item = {}
        self.orders = []

        self.mixin('validation')
        self.mixin('permissions')
        self.mixin('change')

        self.rules = {
            name: 'empty'
        }

        self.afterChange = e => {
            let name = e.target.name
            delete self.error[name]
            self.error = {...self.error, ...self.validation.validate(self.item, self.rules, name)}
        }

        self.submit = e => {
            var params = self.item

            self.error = self.validation.validate(self.item, self.rules)

            if (!self.error) {
                API.request({
                    object: 'News',
                    method: 'Save',
                    data: params,
                    success(response) {
                        popups.create({title: 'Успех!', text: 'Изменения сохранены!', style: 'popup-success'})
                        self.item = response
                        self.update()
                        if (self.isNew)
                            riot.route(`/news/${self.item.id}`)
                        observable.trigger('news-reload')
                    }
                })
            }
        }

        self.changeCategory = () => {
            modals.create('new-categories-list-modal', {
                type: 'modal-primary',
                submit() {
                    let items = this.tags.catalog.tags.datatable.getSelectedRows()

                    if (items.length > 0) {
                        self.item.idCategory = items[0].id
                        self.item.nameCategory = items[0].title
                        self.update()
                        this.modalHide()
                    }
                }
            })
        }

        observable.on('news-new', item => {
            let { category, name } = item
            self.error = false
            self.isNew = true
            self.item = {
                publicationDate: (new Date()).toLocaleDateString(),
                publicationDateDisplay: (new Date()).toLocaleDateString(),
                idCategory: category,
                nameCategory: decodeURI(name)
            }
            self.update()
        })

        observable.on('news-edit', id => {
            var params = {id: id}
            self.error = false
            self.isNew = false
            self.loader = true
            self.item = {}

            API.request({
                object: 'News',
                method: 'Info',
                data: params,
                success: (response, xhr) => {
                    self.item = response
                    self.loader = false
                    self.update()
                },
                error(response) {
                    self.item = {}
                    self.loader = false
                    self.update()
                }
            })
        })

        self.reload = () => {
            self.item.id ? observable.trigger('news-edit', self.item.id) : observable.trigger('news-new')
        }

        self.on('mount', () => {
            riot.route.exec()
        })
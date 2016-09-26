| import 'components/datatable.tag'
//| import 'pages/images/images-gallery-modal.tag'


product-edit-images
    .row
        .col-md-12
            catalog-static(name='{ opts.name }', cols='{ cols }', rows='{ value }', handlers='{ handlers }',
            catalog='{ catalog }', upload='{ upload }')
                #{'yield'}(to='toolbar')
                    .form-group(if='{ checkPermission("images", "0100") }')
                        .input-group(class='btn btn-primary btn-file')
                            input(name='files', onchange='{ opts.upload }', type='file', multiple='multiple', accept='image/*')
                            i.fa.fa-plus
                            |  Добавить
                    .form-group(if='{ checkPermission("images", "1000") }')
                        button.btn.btn-success(onclick='{ opts.catalog }', type='button')
                            i.fa.fa-picture-o
                            |  Каталог
                #{'yield'}(to='body')
                    datatable-cell(name='')
                        img(src='{ row.imageUrlPreview }', height='64px', width='64px')
                    datatable-cell(name='')
                        p.form-control-static { row.imageFile }
                        input.form-control(value='{ row.imageAlt }', onchange='{ handlers.imageAltChange }')

    script(type='text/babel').
        var self = this
        self.mixin('permissions')

        Object.defineProperty(self.root, 'value', {
            get() {
                return self.value
            },
            set(value) {
                self.value = value || []
                self.update()
            }
        })

        self.add = () => {}

        self.cols = [
            {name: '', value: 'Картинка'},
            {name: '', value: 'Наименование'},
        ]

        self.handlers = {
            imageAltChange: function (e) {
                e.item.row.imageAlt = e.target.value
            }
        }

        self.catalog = e => {
            modals.create('images-gallery-modal', {
                type: 'modal-primary',
                section: opts.section,
                submit() {
                    self.value = self.value || []
                    this.tags.gallery.items.forEach(item => {
                        if (item.__selected__)
                            self.value.push({
                                imageFile: item.name,
                                imageAlt: self.parent.item.name,
                                imageUrlPreview: app.getImagePreviewURL(item.name, opts.section, opts.size),
                                imageUrl: app.getImageUrl(item.name, opts.section),
                            })
                    })

                    let event = document.createEvent('Event')
                    event.initEvent('change', true, true)
                    self.root.dispatchEvent(event)

                    self.update()
                    this.modalHide()
                }
            })
        }

        self.upload = e => {
            var formData = new FormData();
            var items = []

            for (var i = 0; i < e.target.files.length; i++) {
                formData.append('file'+i, e.target.files[i], e.target.files[i].name)
                items.push(e.target.files[i].name)
            }

            API.upload({
                section: opts.section,
                count: e.target.files.length,
                data: formData,
                success(response) {
                    items = response.items
                    self.value = self.value || []
                    items.forEach(item => {
                        self.value.push({
                            imageFile: item.name,
                            imageAlt: '',
                            imageUrlPreview: item.imageUrlPreview,
                            imageUrl: item.imageUrl,
                        })
                    })

                    let event = document.createEvent('Event')
                    event.initEvent('change', true, true)
                    self.root.dispatchEvent(event)

                    self.update()
                }
            })
        }

        self.on('update', () => {
            if ('name' in opts && opts.name !== '')
                self.root.name = opts.name

            if ('value' in opts)
                self.value = opts.value || []
        })
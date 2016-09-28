| import 'components/datatable.tag'
//| import 'pages/images/images-gallery-modal.tag'


product-edit-images
    .row
        .col-md-12
            catalog-static(name='{ opts.name }', cols='{ cols }', rows='{ value }', handlers='{ handlers }',
            catalog='{ catalog }', upload='{ upload }')
                #{'yield'}(to='toolbar')
                    .form-group(if='{ checkPermission("images", "1000") }')
                        button.btn.btn-success(onclick='{ opts.catalog }', type='button')
                            i.fa.fa-picture-o
                            |  Каталог
                #{'yield'}(to='body')
                    datatable-cell(name='')
                        img(src!='{ app.getImageUrl("/"+row.imagePath) }', height='64px', width='64px')
                    datatable-cell(name='')
                        p.form-control-static { row.imagePath }
                        input.form-control(value='{ row.alt }', onchange='{ handlers.imageAltChange }')

    script(type='text/babel').
        var self = this
        self.mixin('permissions')
        self.app = app

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
                e.item.row.alt = e.target.value
            }
        }

        self.catalog = e => {
            modals.create('images-modal', {
                type: 'modal-primary',
                size: 'modal-lg',
                submit: function () {
                    let filemanager = this.tags.filemanager
                    let items = filemanager.getSelectedFiles()
                    let path = filemanager.path

                    items.forEach(item => {
                        self.value.push({
                            imagePath: `${path}/${item.name}`
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

        self.on('update', () => {
            if ('name' in opts && opts.name !== '')
                self.root.name = opts.name

            if ('value' in opts)
                self.value = opts.value || []
        })
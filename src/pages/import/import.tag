| import './import-file.tag'
| import './import-fields.tag'
| import './import-settings.tag'
| import './import-result.tag'

import
    h3 Импорт из XLSX, XLS, CSV
    loader(if='{ loader }')
    h4(if='{ step == "file" }') Шаг 1. Файл данных
    h4(if='{ step == "fields" }') Шаг 2. Структура данных
    h4(if='{ step == "settings" }') Шаг 3. Настройки импорта
    h4(if='{ step == "result" }') Результат импорта

    form(onchange='{ change }', onkeyup='{ change }')
        import-file(if='{ step == "file" }')
        import-fields(if='{ step == "fields" }')
        import-settings(if='{ step == "settings" }')
        import-result(if='{ step == "result" }')

    script(type='text/babel').
        var self = this

        self.item = {
            encoding: "auto",
            separator: "auto",
            skipCountRows: 1,
        }

        self.mixin('change')

        self.loader = false
        self.step = "file"
        self.fileSelected = false
        self.groups = []
        self.brands = []

        self.changeFile = (e) => {
            self.item.filename = e.target.files[0].name
            self.fileSelected = true
            self.update()
        }

        self.loadFile = () => {
            let formData = new FormData()
            let importForm = self.tags["import-file"]
            let target = importForm.file

            formData.append('separator', self.item.separator)
            formData.append('encoding', self.item.encoding)
            formData.append('filename', target.files[0].name)
            formData.append('skipCountRows', self.item.skipCountRows)
            formData.append('file', target.files[0], target.files[0].name)
            self.loader = true
            self.update()

            API.upload({
                object: 'Import',
                data: formData,
                success(response) {
                    self.step = "fields"
                    self.item = response
                    if (!self.item.keyField)
                        self.item.keyField = "article"
                    if (!self.item.folderImages)
                        self.item.folderImages = "/"
                },
                complete() {
                    self.loader = false
                    self.update()
                }
            })
        }

        self.setSettings = () => {
            self.step = "settings"
            self.update()
        }

        self.back = () => {
            if (self.step == "fields")
                self.step = "file"
            if (self.step == "settings")
                self.step = "fields"
            self.update()
        }

        self.exec = () => {
            self.loader = true
            self.update()

            API.request({
                object: 'Import',
                method: 'Exec',
                data: self.item,
                success() {

                },
                complete() {
                    self.step = "result"
                    self.loader = false
                    self.update()
                }
            })
        }

        self.catalog = () => riot.route(`/products`)

        self.newImport = () => {
            self.item = {
                encoding: "auto",
                separator: "auto",
                skipCountRows: 1,
            }

            self.loader = false
            self.step = "file"
            self.update()
        }

        self.loadGroups = () => {
            let data = { sortBy: "name", sortOrder: "asc" }
            API.request({
                object: 'Category',
                method: 'Fetch',
                data: data,
                success(response) {
                    self.groups = response.items
                }
            })
        }

        self.loadBrands = () => {
            let data = { sortBy: "name", sortOrder: "asc", limit: 1000 }
            API.request({
                object: 'Brand',
                data: data,
                method: 'Fetch',
                success(response) {
                    self.brands = response.items
                }
            })
        }

        self.loadGroups()
        self.loadBrands()
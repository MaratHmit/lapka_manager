| import './import-file.tag'
| import './import-fields.tag'
| import './import-result.tag'

import
    h3 Импорт из XLSX, XLS, CSV
    loader(if='{ loader }')
    h4(if='{ step == "file" }') Шаг 1. Файл данных
    h4(if='{ step == "fields" }') Шаг 2. Структура данных
    h4(if='{ step == "result" }') Результат импорта

    form(onchange='{ change }', onkeyup='{ change }')
        import-file(if='{ step == "file" }')
        import-fields(if='{ step == "fields" }')
        import-result(if='{ step == "result" }')

    script(type='text/babel').
        var self = this

        self.item = {
            encoding: "auto",
            separator: "auto",
            skipCountRows: 1
        }
        self.loader = false
        self.step = "file"
        self.fileSelected = false

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
                },
                complete() {
                    self.loader = false
                    self.update()
                }
            })
        }

        self.back = () => {
            if (self.step == "fields")
                self.step = "file"
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
                    //self.step = "result"
                    self.loader = false
                    self.update()
                }
            })
        }

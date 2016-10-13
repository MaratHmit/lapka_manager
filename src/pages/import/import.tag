| import './import-file.tag'
| import './import-fields.tag'

import
    h3 Импорт из XLSX, XLS, CSV

    import-file(if='{ step == "file" }')
    import-fields(if='{ step == "fields" }')

    script(type='text/babel').
        var self = this

        self.item = {}
        self.loader = false
        self.step = "file"
        self.fileSelected = false

        self.changeFile = (e) => {
            self.filename = e.target.files[0].name
            self.fileSelected = true
            self.update()
        }

        self.loadFile = () => {
            let formData = new FormData()
            let importForm = self.tags["import-file"]
            let target = importForm.file
            formData.append('separator', importForm.separator.value)
            formData.append('encoding', importForm.encoding.value)
            formData.append('file', target.files[0], target.files[0].name)
            self.loader = true

            API.upload({
                object: 'Import',
                data: formData,
                success(response) {
                    //self.step = "fields"
                },
                complete() {
                    self.loader = false
                    self.update()
                }
            })

        }

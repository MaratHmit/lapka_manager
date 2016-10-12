| import './import-file.tag'
| import './import-fields.tag'

import
    h3 Импорт из XLSX, XLS, CSV

    import-file(if='{ step == "file" }')
    import-fields(if='{ step == "fields" }')

    script(type='text/babel').
        var self = this

        self.item = {}
        self.step = "file"

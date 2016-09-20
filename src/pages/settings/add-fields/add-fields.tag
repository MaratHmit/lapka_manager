| import './add-fields-edit-modal.tag'
| import './add-fields-groups.tag'
| import './add-fields-list.tag'

add-fields
    h4 Поля

    ul.nav.nav-tabs.m-b-2
        li.active #[a(data-toggle='tab', href='#add-fields-orders') Заказы]
        li #[a(data-toggle='tab', href='#add-fields-contacts') Контакты]
        li #[a(data-toggle='tab', href='#add-fields-company') Компании]

    .tab-content
        #add-fields-orders.tab-pane.fade.in.active
            add-fields-list(type='{ "order" }')
        #add-fields-contacts.tab-pane.fade
            add-fields-list(type='{ "contact" }')
        #add-fields-company.tab-pane.fade
            add-fields-list(type='{ "company" }')
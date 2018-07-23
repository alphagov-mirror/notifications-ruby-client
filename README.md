# GOV.UK Notify Ruby client

This documentation is for developers interested in using this Ruby client to integrate their government service with GOV.UK Notify.

[![Gem Version](https://badge.fury.io/rb/notifications-ruby-client.svg)](https://badge.fury.io/rb/notifications-ruby-client)

## Table of Contents

* [Installation](#installation)
* [Getting started](#getting-started)
* [Send messages](#send-messages)
* [Get the status of one message](#get-the-status-of-one-message)
* [Get the status of all messages](#get-the-status-of-all-messages)
* [Get a template by ID](#get-a-template-by-id)
* [Get a template by ID and version](#get-a-template-by-id-and-version)
* [Get all templates](#get-all-templates)
* [Generate a preview template](#generate-a-preview-template)
* [Get received texts](#get-received-texts)

## Installation

Prior to usage an account must be created through the Notify admin console. This will allow access to the API credentials you application.

You can then install the gem or require it in your application.

```
gem install 'notifications-ruby-client'
```

## Getting started

```ruby
require 'notifications/client'
client = Notifications::Client.new(api_key)
```

Generate an API key by logging in to GOV.UK Notify [GOV.UK Notify](https://www.notifications.service.gov.uk) and going to the **API integration** page.

## Send messages

### Text message

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
sms = client.send_sms(
  phone_number: number,
  template_id: template_id,
  personalisation: {
    name: "name",
    year: "2016",                      
  },
  reference: "your_reference_string",
  sms_sender_id: sms_sender_id
) # => Notifications::Client::ResponseNotification
```

</details>

#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.
<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
sms => Notifications::Client::ResponseNotification

sms.id         # => uuid for the notification
sms.reference  # => Reference string you supplied in the request
sms.content    # => Hash containing body => the message sent to the recipient, with placeholders replaced.
               #                    from_number => the sms sender number of your service found **Settings** page
sms.template   # => Hash containing id => id of the template
               #                    version => version of the template
               #                    uri => url of the template
sms.uri        # => URL of the notification
```


Otherwise the client will raise a `Notifications::Client::RequestError`:

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `phone_number`

The phone number of the recipient, only required for sms notifications.

##### `template_id`

Find by clicking **API info** for the template you want to send.

##### `reference`

An optional identifier you generate. The `reference` can be used as a unique reference for the notification. Because Notify does not require this reference to be unique you could also use this reference to identify a batch or group of notifications.

You can omit this argument if you do not require a reference for the notification.

##### `personalisation`

If a template has placeholders, you need to provide their values, for example:

```python
personalisation={
    'first_name': 'Amala',
    'reference_number': '300241',
}
```
##### `sms_sender_id`

Optional. Specifies the identifier of the sms sender to set for the notification. The identifiers are found in your service Settings, when you 'Manage' your 'Text message sender'.

If you omit this argument your default sms sender will be set for the notification.

</details>


### Email

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
email = client.send_email(
  email_address: email_address,
  template_id: template_id,
  personalisation: {
    name: "name",
    year: "2016"
  },
  reference: "your_reference_string",
  email_reply_to_id: email_reply_to_id
) # => Notifications::Client::ResponseNotification
```

</details>


#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
email => Notifications::Client::ResponseNotification

email.id         # => uuid for the notification
email.reference  # => Reference string you supplied in the request
email.content    # => Hash containing body => the message sent to the recipient, with placeholders replaced.
                 #                    subject => subject of the message sent to the recipient, with placeholders replaced.
                 #                    from_email => the from email of your service found **Settings** page
email.template   # => Hash containing id => id of the template
                 #                    version => version of the template
                 #                    uri => url of the template
email.uri        # => URL of the notification
```

Otherwise the client will raise a `Notifications::Client::RequestError`:

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `email_address`
The email address of the recipient, only required for email notifications.

##### `template_id`

Find by clicking **API info** for the template you want to send.

##### `reference`

An optional identifier you generate. The `reference` can be used as a unique reference for the notification. Because Notify does not require this reference to be unique you could also use this reference to identify a batch or group of notifications.

You can omit this argument if you do not require a reference for the notification.

##### `email_reply_to_id`

Optional. Specifies the identifier of the email reply-to address to set for the notification. The identifiers are found in your service Settings, when you 'Manage' your 'Email reply to addresses'.

If you omit this argument your default email reply-to address will be set for the notification.

##### `personalisation`

If a template has placeholders, you need to provide their values, for example:

```python
personalisation={
    'first_name': 'Amala',
    'application_number': '300241',
}
```

</details>


### Letter

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
letter = client.send_letter(
  template_id: template_id,
  personalisation: {
    address_line_1: 'Her Majesty The Queen',  # required
    address_line_2: 'Buckingham Palace', # required
    address_line_3: 'London',
    postcode: 'SW1 1AA',  # required

    ... # any other personalisation found in your template
  },
  reference: "your_reference_string"
) # => Notifications::Client::ResponseNotification
```

</details>


#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
letter => Notifications::Client::ResponseNotification

letter.id           # => uuid for the notification
letter.reference    # => Reference string you supplied in the request
letter.content      # => Hash containing body => the body of the letter sent to the recipient, with placeholders replaced
                    #                    subject => the main heading of the letter
letter.template     # => Hash containing id => id of the template
                    #                    version => version of the template
                    #                    uri => url of the template
letter.uri          # => URL of the notification
```

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

#### `template_id`
Find by clicking **API info** for the template you want to send.

#### `reference`
An optional identifier you generate. The `reference` can be used as a unique reference for the notification. Because Notify does not require this reference to be unique you could also use this reference to identify a batch or group of notifications.

You can omit this argument if you do not require a reference for the notification.

#### `personalisation`
If the template has placeholders you need to provide their values as a Hash, for example:

```ruby
  personalisation: {
    'first_name' => 'Amala',
    'reference_number' => '300241',
  }
```

You can omit this argument if the template does not contain placeholders and is for email or sms.

#### `personalisation` (for letters)

If you are sending a letter, you will need to provide the letter fields in the format `"address_line_#"`, for example:

```ruby
personalisation: {
    'address_line_1' => 'The Occupier',
    'address_line_2' => '123 High Street',
    'address_line_3' => 'London',
    'postcode' => 'SW14 6BH',
    'first_name' => 'Amala',
    'reference_number' => '300241',
}
```

The fields `address_line_1`, `address_line_2` and `postcode` are required.

</details>


## Get the status of one message

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
notification = client.get_notification(id) # => Notifications::Client::Notification
```

</details>


#### Response

If successful a `Notifications::Client::Notification` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
notification.id                     # => uuid for the notification
notification.reference              # => reference string you supplied in the request
notification.email_address          # => email address of the recipient (for email notifications)
notification.phone_number           # => phone number of the recipient (for SMS notifications)
notification.line_1                 # => line 1 of the address of the recipient (for letter notifications)
notification.line_2                 # => line 2 of the address of the recipient (for letter notifications)
notification.line_3                 # => line 3 of the address of the recipient (for letter notifications)
notification.line_4                 # => line 4 of the address of the recipient (for letter notifications)
notification.line_5                 # => line 5 of the address of the recipient (for letter notifications)
notification.line_6                 # => line 6 of the address of the recipient (for letter notifications)
notification.postcode               # => postcode of the recipient (for letter notifications)
notification.type                   # => type of notification sent (sms, email or letter)
notification.status                 # => notification status (sending / delivered / permanent-failure / temporary-failure / technical-failure)
notification.template               # => uuid of the template
notification.body                   # => body of the notification
notification.subject                # => the subject of the notification (email notifications only)
notification.sent_at                # => date and time the notification was sent to the provider
notification.created_at             # => date and time the notification was created
notification.completed_at           # => date and time the notification was delivered or failed
notification.created_by_name        # => name of the person who sent the notification if sent manually
```
Otherwise a `Notification::Client::RequestError` is raised

|`error.code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`404`|`[{`<br>`"error": "ValidationError",`<br>`"message": "is not a valid UUID"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `id`

The ID of the notification.

</details>

## Get the status of all messages

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
# See section below for a description of the arguments.
# This will return 250 of the most recent messages over the last 7 days, if `older_than` is omitted.
# The following 250 messages can be accessed through the hash `notifications.links["next"]`
args = {
  'template_type' => 'sms',
  'status' => 'failed',
  'reference' => 'your reference string'
  'older_than' => 'e194efd1-c34d-49c9-9915-e4267e01e92e' # => Notifications::Client::Notification
}
notifications = client.get_notifications(args)
```

</details>


#### Response

If the request is successful a `Notifications::Client::NotificationsCollection` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
notifications.links # => Hash containing current => "/notifications?template_type=sms&status=delivered"
                    #                    next => "/notifications?older_than=last_id_in_list&template_type=sms&status=delivered"
notifications.collection # => [] (array of notification objects)
```

Otherwise the client will raise a `Notifications::Client::RequestError`:

|`error.status_code`|`error.message`|
|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "bad status is not one of [created, sending, delivered, pending, failed, technical-failure, temporary-failure, permanent-failure]"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Apple is not one of [sms, email, letter]"`<br>`}]`|

</details>

#### Arguments

Omit the argument Hash if you do not want to filter the results.

<details>
<summary>
Click here to expand for more information.
</summary>

##### `template_type`

If omitted all messages are returned. Otherwise you can filter by:

* `email`
* `sms`
* `letter`

You can omit this argument to ignore the filter.

##### `status`

You can filter by:

* `sending` - the message is queued to be sent by the provider.
* `delivered` - the message was successfully delivered.
* `failed` - this will return all failure statuses `permanent-failure`, `temporary-failure` and `technical-failure`.
* `permanent-failure` - the provider was unable to deliver message, email or phone number does not exist; remove this recipient from your list.
* `temporary-failure` - the provider was unable to deliver message, email box was full or the phone was turned off; you can try to send the message again.
* `technical-failure` - Notify had a technical failure; you can try to send the message again.

You can omit this argument to ignore the filter.

##### `reference`

This is the `reference` you gave at the time of sending the notification. The `reference` can be a unique identifier for the notification or an identifier for a batch of notifications.

You can omit this argument to ignore the filter.


##### `older_than`
You can get the notifications older than a given `Notification.id`.
You can omit this argument to ignore this filter.

</details>



## Get a template by ID

#### Method

This will return the latest version of the template. Use [getTemplateVersion](#get-a-template-by-id-and-version) to retrieve a specific template version.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
template = client.get_template_by_id(id)
```

</details>


#### Response

<details>
<summary>
Click here to expand for more information.
</summary>

```Ruby
template.id         # => uuid for the template
template.type       # => type of template one of email|sms|letter
template.created_at # => date and time the template was created
template.updated_at # => date and time the template was last updated, may be null if version 1
template.created_by # => email address of the person that created the template
template.version    # => version of the template
template.body       # => content of the template
template.subject    # => subject for email templates, will be empty for other template types
```

Otherwise the client will raise a `Notifications::Client::RequestError`.

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

|`error.code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`404`|`[{`<br>`"error": "ValidationError",`<br>`"message": "is is not a valid UUID"`<br>`}]`|

##### `id`
The template id is visible on the template page in the application.

</details>


## Get a template by ID and version

#### Method

This will return the template for the given id and version.
<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
Template template = client.get_template_version(id, version)
```

</details>


#### Response

<details>
<summary>
Click here to expand for more information.
</summary>


```Ruby
template.id         # => uuid for the template
template.type       # => type of template one of email|sms|letter
template.created_at # => date and time the template was created
template.updated_at # => date and time the template was last updated, may be null if version 1
template.created_by # => email address of the person that created the template
template.version    # => version of the template
template.body       # => content of the template
template.subject    # => subject for email templates, will be empty for other template types
```

Otherwise the client will raise a `Notifications::Client::RequestError`.

|`error.code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`404`|`[{`<br>`"error": "ValidationError",`<br>`"message": "is is not a valid UUID"`<br>`}]`|

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

#### `id`
The template id is visible on the template page in the application.

#### `version`
A history of the template is kept. There is a link to `See previous versions` on the template page in the application.

</details>


## Get all templates

#### Method

This will return the latest version of each template for your service.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
args = {
  'template_type' => 'sms'
}
templates = client.get_all_templates(args)
```


</details>


#### Response

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
    TemplateCollection templates;
```
If the response is successful, a TemplateCollection is returned.

If no templates exist for a template type or there no templates for a service, the templates list will be empty.

Otherwise the client will raise a `Notifications::Client::RequestError`.

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `template_type`
If omitted all templates are returned. Otherwise you can filter by:

* `email`
* `sms`
* `letter`

</details>


## Generate a preview template

#### Method

This will return the contents of a template with the placeholders replaced with the given personalisation.

<details>
<summary>
Click here to expand for more information.
</summary>


```ruby
templatePreview = client.generate_template_preview(id,
                                                  personalisation: {
                                                      name: "name",
                                                      year: "2016",                      
                                                    })
```

</details>


#### Response

<details>
<summary>
Click here to expand for more information.
</summary>

```Ruby
template.id         # => uuid for the template
template.version    # => version of the template
template.body       # => content of the template
template.subject    # => subject for email templates, will be empty for other template types
template.type       # => type of notification the template is for (sms, email or letter)
```
Otherwise a `Notifications::Client::RequestError` is thrown.

|`error.code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`404`|`[{`<br>`"error": "ValidationError",`<br>`"message": "is is not a valid UUID"`<br>`}]`|

</details>


#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `id`
The template id is visible on the template page in the application.

##### `personalisation`
If a template has placeholders, you need to provide their values. `personalisation` can be an empty or null in which case no placeholders are provided for the notification.

</details>

## Get received texts
#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
# See section below for a description of the arguments.
# This will return 250 of the most recent messages over the last 7 days, if `older_than` is omitted.
# The following 250 messages can be accessed through the hash `received_texts.links["next"]`
args = {
  'older_than' => 'e194efd1-c34d-49c9-9915-e4267e01e92e' # => Notifications::Client::ReceivedText
}
received_texts = client.get_received_texts(args)
```

</details>


#### Response

If the request is successful a `Notifications::Client::ReceivedTextCollection` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

`ReceivedTextCollection` -

```ruby
received_texts.links # => Hash containing current => "/v2/received-text-messages"
                     #                    next => "/v2/received-text-messages?older_than=last_id_in_list"
received_texts.collection # => [] (array of ReceivedText objects)
```

`ReceivedText` -

```ruby
received_text.id            # => uuid for the received text
received_text.created_at    # => created_at of the received text
received_text.content       # => content of the received text
received_text.notify_number # => number received text was sent to
received_text.service_id    # => service id of the received text
received_text.user_number   # => number received text was sent from

```

</details>

#### Arguments

Omit the argument Hash if you do not want to filter the results.

<details>
<summary>
Click here to expand for more information.
</summary>

##### `older_than`
You can get the notifications older than a given `received_text.id`.
You can omit this argument to ignore this filter.

</details>

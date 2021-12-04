1. Create a `<locale>.yml` file in config/ using the relevant [two-letter ISO language code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).

 For example, `en.yml` for English, `fr.yml` for French, etc.

2. Use `en.yml` as a reference to translate the variables
3. Include your locale in
  -  **available_locales** in [the application_helper](https://github.com/andrew/24pullrequests/blob/master/app/helpers/application_helper.rb) 
  -  the [application configuration](https://github.com/andrew/24pullrequests/blob/master/config/application.rb#L40)
  - the first line in your language file
4. Get the country image for your language from [this dropbox folder](https://www.dropbox.com/sh/vlpojkh1jhk5roo/XbLTTeZVNO), rename it to match the name of the locale, and place it in `app/assets/images/flags`.
5. Don't forget to add the translated version of your language in `en.yml` under the `locale` namespace!

If you then run the application, you should see an option for the language (along with the flag image next to it) in the **Language** dropdown!
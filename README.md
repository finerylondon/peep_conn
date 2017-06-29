Ruby Gem: Peoplevox API

The PeepConn gem provides an easy access point to the PeopleVox API. The code consists of a Connection class to build a session, from which its sub-classes inherit a constructor.

These three sub-classes handle the three main functions required of a connection.

Export

The Export class creates and updates data in the PeopleVox API.

This data is passed as an argument in hash format containing the keys :type (a PeopleVox table) and :csv (the values, matched to the corresponding PeopleVox GUI table headers).

The type can be supplied as a spree singular class name (i.e. ‘address’) or the PeopleVox table name (‘Customer addresses‘). These are mapped in `PeepConn::Constants.TABLE_NAMES`.

A second argument can be supplied to :export, with custom headers in CSV format replacing the defaults. The defaults can be retrieved by providing a table name to the `:template_columns_for(type)` method.

Example:

PeepConn::Export.new(config).export({ type: 'user', csv: 'steve, steve@finerylondon.com' }, 'name, email')

Query

The Query class is for retrieving data from PeopleVox. The :retrieve method takes a table name, returning all its data. An options hash can be supplied to refine this, with keys for :per_page, :page and :term. The latter takes Microsoft LINQ style expressions.

Example:

PeepConn::Query.new(config).retrieve('user', term: 'name.Contains(“Neil”)')

Subscription

The Subscription class sets up PeopleVox callbacks for the following events:

Stock availability changes
Order status changes
Tracking received
The subscriptions need refreshing whenever the base url changes (i.e. a new ngrok channel in dev), using the :refresh_subscriptions method. This method iterates through 1 – 100 unsubscribing existing subs by ID, before creating a new callback for each event. There’s no way to retrieve or query callbacks, and the gem will need updating once over 100 subscriptions have existed.

Config

The config value passed to the constructor of all classes contains auth info for the PeopleVox connection. This is currently a hash containing values for :client_id, :username, :password and :url (their endpoint).

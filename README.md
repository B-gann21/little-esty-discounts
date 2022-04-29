# Bulk Discounts
This project is an extension of the Little Esty Shop group project. You will add functionality for merchants to create bulk discounts for their items. A “bulk discount” is a discount based on the quantity of items the customer is buying, for example “20% off orders of 10 or more items”.

## Requirements
- Rails 5.2.x
- PostgreSQL

## Setup

This project requires Ruby 2.7.4.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:{create,migrate}`
* Run the test suite with `bundle exec rspec`.
* If you are running the server locally, you must run `rails csv_load:all` to seed the database with Merchants, Items and Invoices
* Run your development server with `rails s` to see the app in action.

# Learning Goals
- Write migrations to create tables and relationships between tables
- Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
- Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one - or more attributes
- Write model tests that fully cover the data logic of the application
- Write feature tests that fully cover the functionality of the application

## Bulk Discounts are subject to the following criteria:

- Bulk discounts should have a percentage discount as well as a quantity threshold
- Bulk discounts should belong to a Merchant
- A Bulk discount is eligible for all items that the merchant sells. Bulk discounts for one merchant should not affect items sold by another merchant
  - Merchants can have multiple bulk discounts
- If an item meets the quantity threshold for multiple bulk discounts, only the one with the greatest percentage discount should be applied
- Bulk discounts should apply on a per-item basis
- If the quantity of an item ordered meets or exceeds the quantity threshold, then the percentage discount should apply to that item only. Other items that did not meet the quantity threshold will not be affected.
The quantities of items ordered cannot be added together to meet the quantity thresholds, e.g. a customer cannot order 1 of Item A and 1 of Item B to meet a quantity threshold of 2. They must order 2 of Item A and/or 2 of Item B

### Interaction with this web app is described through the following user stories. They can be performed by visiting [the heroku app](https://etsy-bulk-discounts.herokuapp.com) and adding '/{uri}' to the end of the url bar, or by running `rails s` in your terminal and navigating to `localhost:3000/{uri}`.

User Stories - 
```
Merchant Bulk Discounts Index

As a merchant
When I visit my merchant dashboard (example URI: /merchants/50/dashboard)
Then I see a link to view all my discounts
When I click this link
Then I am taken to my bulk discounts index page
Where I see all of my bulk discounts including their
percentage discount and quantity thresholds
And each bulk discount listed includes a link to its show page
```

```
Merchant Bulk Discount Create

As a merchant
When I visit my bulk discounts index (example URI: /merchants/50/bulk_discounts)
Then I see a link to create a new discount
When I click this link
Then I am taken to a new page where I see a form to add a new bulk discount
When I fill in the form with valid data
Then I am redirected back to the bulk discount index
And I see my new bulk discount listed
```

```
Merchant Bulk Discount Delete

As a merchant
When I visit my bulk discounts index
Then next to each bulk discount I see a link to delete it
When I click this link
Then I am redirected back to the bulk discounts index page
And I no longer see the discount listed
```
```
Merchant Bulk Discount Show

As a merchant
When I visit my bulk discount show page (example URI: '/merchants/50/bulk_discounts')
Then I see the bulk discount's quantity threshold and percentage discount
```

```
Merchant Bulk Discount Edit

As a merchant
When I visit my bulk discount show page (example URI: '/merchants/50/bulk_discounts/10')
Then I see a link to edit the bulk discount
When I click this link
Then I am taken to a new page with a form to edit the discount
And I see that the discounts current attributes are pre-poluated in the form
When I change any/all of the information and click submit
Then I am redirected to the bulk discount's show page
And I see that the discount's attributes have been updated
```

```
Merchant Invoice Show Page: Total Revenue and Discounted Revenue

As a merchant
When I visit my merchant invoice show page (example URI: '/merchants/50/invoices/621')
Then I see the total revenue for my merchant from this invoice (not including discounts)
And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
```

```
Merchant Invoice Show Page: Link to applied discounts

As a merchant
When I visit my merchant invoice show page
Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
```

```
Admin Invoice Show Page: Total Revenue and Discounted Revenue

As an admin
When I visit an admin invoice show page (example URI: '/admin/invoices/631')
Then I see the total revenue from this invoice (not including discounts)
And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
```

```
As a merchant
When I visit the discounts index page
I see a section with a header of "Upcoming Holidays"
In this section the name and date of the next 3 upcoming US holidays are listed.

Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
```

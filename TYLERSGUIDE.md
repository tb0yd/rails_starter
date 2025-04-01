# Tyler's Guide to Writing Rails Apps That Outlive Empires

## 1. How to Read This Document

- The specific clarifies the general. If there are two rules that appear to contradict each other, with one specific and the other more general, follow the rule that's more specific.
- Pre-existing patterns in the codebase should take precendence over the patterns described in this guide. If this guide conflicts with something already found in the codebase, follow what's in the codebase.
- After section 3, the Guide is split into required and optional patterns:
  - Required patterns are design patterns that should already be implemented in a good codebase. If not, they should be implemented without asking and without being asked, to serve as an example for later code.
  - Optional patterns are approved ways of solving specific problems. These problems are given inside each pattern description, usually under "Purpose". For example, the "Prawn" gem is an optional patterns, so it should be included in the project at the time that PDF generation is requested, not before, and no other PDF generation library should be used.

## 2. Things to Never Do (Long Version)

- Never use Rubocop - it's antithetical to the spirit of Ruby, which is meant to be expressive and flexible.
- Never use metaprogramming - usually the basic language constructs are sufficient and more readable anyway.
- Never use any ORM except ActiveRecord. It's the standard.
- Never write a default scope to a model (Paranoia installs its own default scope - that's OK).
- Never make methods private unless it's in a controller. Strict encapsulation doesn't make much sense unless you're distributing code to be used widely.
- Never name anything using the word "service" except third-party (external) integrations, i.e. RESTful APIs.
- Never reinvent something that has been provided by Ruby's standard library, Ruby on Rails, or any of the active* gems bundled with Rails like `activemodel`, `activesupport`, etc.
- Never save enums to the database as integers. Use abbreviated strings instead.
  - **Example:** `enum sex: { female: 'fem', male: 'mal' }`
- Never generate HTML with Ruby helper code using `content_tag`, `capture`, etc. ERb is the only way HTML should be generated.
- Never inline JavaScript or CSS inside a view partial using `<script>` or `<style>` tags. It's okay in a layout if a third-party JS library demands it.
- Never use any front-end framework other than StimulusJS or JQuery. Two is enough already.
- Never access a Thread-local variable (such as current account or current user) from inside the model code. This keeps the model code accessible from various contexts (tests, tasks, irb, etc.) without messing with Thread-local vars.
- Never use Cucumber or TestUnit for testing. RSpec is the accepted more widely by the community.
- Never use the Null Object, Decorator, Observer, Adapter, Presenter, or Visitor patterns. These are habits carried over from other programming languages.
- Never refactor code just because it's getting too long, unless it's a Ruby controller. Ruby controllers are the only files in which files must be short.
- Never use the JSON data type in the database. If JSON must be stored, parse out all the major values into columns and store it as a text blob (for light deployment) or file in S3 (for heavy deployment).
- Never define database constraints. Do all data integrity checks on the application layer (validations).
- Never automatically update production data. Require human confirmation even in YOLO mode.
- Never write code comments that only restate the code in English. It just clutters the code. The code should be readable on its own.
- Never raise exceptions to control the flow of the code. Exceptions are only for exceptional events like system errors, etc.
- Never include any abandonware (gems that haven't been updated in more than 4 years). If you need a small gem (<200 LoC) that's abandonware, copy the classes directly into the project in `lib/` with a link to the original repository in a comment.

## 3. General Style Guidelines

### 3.1 Ruby Style Guide

- When writing code outside Rails conventions, prefer procedural style over object-oriented style. Prefer object-oriented style over functional style.
- Prefer short method signatures; one or two arguments is ideal. Prefer to use keyword arguments once the number of arguments goes above two.
- Prefer flat file structures and long filenames/class names over nested folder structures and namespaces.
- Prefer nested conditionals over multiple guard statements in a single method.
- Avoid long predicates.
- Avoid rescuing specific exceptions—instead, break the method up and add a separate rescue catch-all for each small method.
- Prefer string interpolation over concatenation.
- Prefer symbol keys to string keys in hashes, and use `with_indifferent_access` and `symbolize_names` to enable them.
- Prefer objects with multiple attributes over multiple return values.
- Prefer modules to classes, in general.
- Prefer short or abbreviated names for throwaway variables or intermediate variables.
  - **Example:** For an integer counter in a loop, `index`, `ix`, or even just `i` is fine.
- Prefer to provide access to methods of other classes using `delegate` method over adhering to strict encapsulation.
- Prefer to memoize a method using the `memoize` directive (Memoist gem) directly under the method itself over using the `@method_name ||= begin ... end` pattern.

### 3.2 Rails Models

Model classes are the central point for business logic in the application. They are written to be used in a variety of contexts. As such, they are expected to be long and do many different things.

- Do not limit the length of model classes.
- Prefer a flat directory structure (putting code directly in `app/models`). Only exception is `app/model/concerns`.
- Only DRY up code into a module if it's been duplicated at least 3 times (2 times for long code blocks, like 15+ lines).
- Typically, there will be one model that serves as the "main model," central to most business logic. This becomes clear once the codebase has grown to be about medium size. Expect the main model to become very long.
  - **Example:** In a social network app, `User` would be the main model.
  - **Example:** In a billing app, `Transaction` would be the main model.
- Highly recommended Rails patterns:
  - Associations
  - Scopes
  - Virtual attributes with `attr_accessor`
  - Lifecycle callbacks (`after_save`, etc.)
  - Validations
- Banned Rails patterns:
  - Single-Table Inheritance. Instead, if two models are very close, just make them two use cases of one model.
  - State machine. Instead, infer state from other columns such as timestamps of important actions.
- When writing plain ol' Ruby objects, write them as virtual models (models that don't subclass `ActiveRecord::Base` but do include some functionality from `ActiveModel`).

### 3.2.1 Database Design

- Use PostgreSQL as the primary database for production.
- Follow Rails naming conventions for table and column names (snake_case, plural for tables, singular for models).
- Always add timestamps (`created_at`, `updated_at`) to tables unless explicitly unnecessary.
- Use indexes on any columns that will be searched or filtered on.
- Never store denormalized data unless caching performance outweighs normalization benefits.
- Prefer `has_many :through` over `has_and_belongs_to_many` for many-to-many relationships.
- Use database transactions for operations that span multiple records.

### 3.3 Rails Controllers

Controllers should be as skinny as possible. The responsibilities of a controller are:

1. Collect the request params (using Rails' strong params).
2. Initialize the necessary models and services to present to the view.
3. Decide which view is going to be rendered (and format, status code, flash messages, etc.).

- Namespace classes and organize files into subfolders based roughly on the URL structure created by the routes.
  - ex. `GET /users/1/transactions` becomes `Users::TransactionsController#index` placed in `app/controllers/users/transactions_controller.rb`
- Controller code must be kept lean and short. It should be organized into:
  - Actions (public methods with a defined Rails route).
  - Private methods that can be defined as callback methods.
  - Concerns (in `/app/controllers/concerns`).
- Prefer putting small reusable callback methods in base controllers (`ApplicationController`) over extracting to concerns. The base controller can be longer than other controllers from all these private methods.

### 3.4 Rails Views

- Enable Turbo site-wide by default.
- Always use ERB for HTML-based views.
- Turbo Stream format views should also use ERb (file type: `.turbo_stream.erb`)
- Organize view files strictly according to the controller that calls them.
- Break views into partials wherever it makes sense, but reuse partials only within the same folder.
- Do not use a `shared` folder for view partials. Instead, place layout-specific partials in `app/views/layouts`.
- Use helpers for any logic that generates view-specific output that does not contain HTML.

### 3.5 Javascript

- Organize front-end JavaScript using StimulusJS.
- Prefer JQuery syntax sugar over Vanilla JS.
- Package JavaScript using ESBuild, including a suitable `build.js` file and `package.json`.
- Place JavaScript files in `app/assets/javascripts/`.
- Write all JavaScript code in ES6. Never write ES5.
- Backporting ES6 to ES5 can be done with Babel as an extra build step in ESBuild, but only include it if explicitly requested.
- Include jQuery and jQuery UI in the project, and prefer writing jQuery over plain ES6.

### 3.6 Stylesheets and SCSS

- Use SCSS (built with Sprockets) for stylesheets and follow best practices.
- Place stylesheets in `app/assets/stylesheets/`.
- Organize SCSS using mixins.
- Define important variables (e.g., breakpoints, common colors, text styles) in `common.scss`, which is imported into every layout file.
- Each layout gets its own SCSS file, included in that layout.
- Use responsive design with well-defined screen size breakpoints.

## 4. Required Patterns

These patterns are patterns that should be built-in to the codebase. If you find that they aren't implemented already, implement them. They will become useful later and help to organize the code as it grows.

### 4.1 Required Libraries

#### 4.1.1 Gems

- Use `Puma` gem for an HTTP server.
- Use `Paranoia` gem for soft deletion.
- Use `Memoist` gem for memoization.
- Use `AuthLogic` for authentication.
- Use `Kaminari` for pagination.
- Use `ActionCable` for Websocket features (real-time updates).
- Use `HTTParty` for third-party services.
- Use `FactoryBot` for test data setup.
- Use `VCR` for testing third-party requests.
- Use `ActiveJob` with a `Resque` backend for workers.

#### 4.1.2 Javascript libraries

- Use `ESBuild` to build Javascript (ES6)
- Use `Twitter Bootstrap` for JS widgets and CSS classes (grid layout, etc.).
- Use `Font Awesome` for icons.
- Use `Select2` for advanced dropdowns.
- Use `jQuery UI` for simple animations and effects.
- Use `DateRangePicker` for selecting date ranges.

### 4.2 Multitenancy

- Most apps will have a need to segregate data according to the user viewing it. Plan for multitenancy from the beginning.
- Segregate data by an Account ID. User is a many-to-many association to Account.
- Include the account ID as a separate column on any model which would need to be segregated by account.
- Initialize a thread-local variable called `current_account_id` at the beginning of every request to the backend (base controller).
- Initialize another thread-local variable called `current_user_id` at the beginning of every request to the backend (base controller).
- Use these thread-local variables in the controllers, helpers, and views.
- If the current account or user is needed in the model code and it's not present on that model, search for it in the associations of that model or pass it in as an argument.
- In the base controller of any controller that needs to be segregated, use ActiveRecord's scoping method in an `around_action` to segregate all data in the table inside a controller.

#### 4.3 Activity Log

Most apps will need to offer users visibility into changes to a model. For this, use the Activity Log pattern.

- Use one table and model for all activity logs (`class ActivityLog < ActiveRecord::Base` works).
- Add a polymorphic association for the logged model.
- Record the model, action (abbreviated string), user, time, and description.
- Map the action to the icon that should be shown.
- Use a uniform UI partial in the `app/views/layouts` folder to display activity logs for all logged models.

#### 4.4 Query Models

hen you need to make a DB query that spans multiple tables and leverages advanced SQL features such as joins, subselects, and unions, use a query model. These models help encapsulate raw SQL logic within a structured, reusable format.

- Write the query model as a virtual model in `app/models`. Name the file with a `_query.rb` suffix (e.g., `UserActivityQuery`). Do not subclass ActiveRecord::Base.
- Define the SQL query as a single long HEREDOC for readability and maintainability.
- Use `attr_accessor` to define initialization parameters, which will be interpolated into the query using sanitized query substitutions (`?`) to prevent SQL injection.
- Return the results by default as a hash of hashes (indifferent access). Use shared modules to handle exporting into different formats such as CSV.

#### 4.5 Services with Request/Response Models

When calling a third-party service, you will want to ensure transparency, debugging capability, and historical tracking of interactions. Achieve this with request/response models.

- Each third-party service will have one or more service classes (one per endpoint), and one pair of request/response models named for that service 
  - (e.g., `TwilioFetchService`, `TwilioUpdateService`, and `TwilioRequest` + `TwilioResponse`).
- The service class files will be in `app/models` and end in `_service.rb`.
- The service classes will include HTTParty and have a single class method that calls the endpoint, and initializes the service class with the HTTP response.
- The service class will also allow initialization directly from a stored response model. 
- The service class will store the response body in `@data` as an Array or Hash. It will have many other methods that query `@data` using `dig` and transform it in various ways.
- The request model will be associated with other database models in the app. The response model will be associated with the request that it's responding to and delegate other associations to the request model.
- The request model (`*Request`) will store:
  - The request body in `request_body` (a blob in light mode, an S3 file in heavy mode).
  - The request `endpoint` as an abbreviated string.
  - The API version as a string.
- The response model (`*Response`) will store:
  - HTTP response code (if it's an HTTP endpoint)
  - HTTP method (if it's an HTTP endpoint)
  - Full response body in `response_body` (a blob in light mode, an S3 file in heavy mode).
  - Any important data extracted from the response as boolean, string, or numerical columns.

### 4.6 AJAX and Turbo

Dynamic UI interactions should use Turbo Streams instead of AJAX to ensure a fast, efficient, and declarative approach to real-time updates. This keeps the UI responsive without requiring unnecessary full-page reloads.

- All forms must be Turbo-enabled and use the `turbo_stream` format. AJAX should only be used for non-navigation actions.
- Controller actions handling form submissions or dynamic updates must respond with the `turbo_stream` format and render a `turbo_stream.erb` view.
- The `.turbo_stream.erb` file should contain `turbo_stream` invocations to update multiple parts of the page efficiently.
  **Example:**
  ```erb
  <%= turbo_stream.replace "messages", partial: "messages/list", locals: { messages: @messages } %>
  ```
- Do not use Turbo Frames. Instead, updates should target standard `<div>` elements using IDs or class names for predictable and flexible DOM manipulation.
- Modal popups, pagination, and flash messages must follow an app-wide standardized pattern. Store ERb partials in `app/views/layouts` and JavaScript modules in `app/javascripts`.

## 4.7. Testing

Practice TDD as much as possible. Always begin assignments by writing a test in one of the 5 approved testing types: model specs, controller specs, view specs, feature specs, and task specs.

- Use **RSpec** for all tests.
- Test code should make up approximately **50%-80%** of the codebase.
- Coverage should be around **85%**, but there's no need to measure it exactly.
- Keep all tests and related code in `spec/`, ending in `_spec.rb`.
  - Write tests in a flat file structure in 5 subfolders: `spec/models`, `spec/controllers`, `spec/views`, `spec/features`, and `spec/tasks`. No other types of tests should be written.
- Use fully descriptive spec file names. 
  - Model, controller, and view spec file names should match the path & filename of the code.
  - Feature spec file names should describe the functionality tested.
  - Task spec file names should mirror the name of the Rake task.
- Model, controller, and task spec test coverage should be high. Feature spec test coverage should be happy path only. View specs should only be written for complex views.
- Prefer slower tests with higher coverage over faster tests with lower coverage.
- Do not DRY test code. Test code should be **repetitive** for clarity.
- Mocks and stubs are highly discouraged. Use `render_views` and perform **full database setup** with **factories** instead.
- Create an .rspec file that automatically runs all 5 approved types of RSpec tests.

## 4.8. Resque Workers

Any critical business process (i.e. billing) or any asynchronous process (i.e. emailing data exports) should be done inside a worker.

- Worker code goes in `app/workers`.
- Configure **`Resque::Failure::Honeybadger`** as the failure backend to ensure errors are captured.  
- Limit job execution time and use **`resque-timeout`** to terminate long-running jobs.  
- **Queue job arguments should always be small** (IDs, not entire objects).  
- Prefer retry logic with **exponential backoff** using **`resque-retry`**.  
- Use **named queues** for different job types to avoid bottlenecks in high-priority jobs.  
- Ensure jobs are idempotent with guard statements that quit early if the job was already run.

## 5. Optional Patterns

These patterns do not come built-in to the system, but are answers to questions, "How should I implement X?" 

### 5.1 Recommended Libraries

#### 5.1.1 Gems

- Use `Prawn` for PDF generation.
- Use `Apipie` for API documentation through code.

#### 5.1.2 JavaScript Libraries

- Use `DataTables` for feature-rich table displays.
- Use `Highcharts` for fancy charts.

#### 5.2 Authorization

When the application has a need for varying access control for different users, prefer to grant access based on user roles (RBAC).

- Avoid gems such as CanCanCan or Pundit for authorization.
- Avoid the Policies pattern.
- Write methods on each model class that begin with `can_`, follow passive voice, end with a question mark, accept a user, and return a boolean. ex.  `can_be_read_by?(user)`, `can_be_updated_by?(user)`, etc. 
  - The methods should check the roles of the passed-in user.
  - Do NOT do account data segregation in the authorization methods. That is only done using around_filters in the base controllers.
  - Extract authorization methods into concerns as appropriate.

#### 5.3 Draft Models

Sometimes a user must build up a record of data over several interactions. A draft model is used for user-created data that has an intermediate stage before becoming finalized. This allows users to save progress, revisit, and complete data entry without requiring immediate commitment.

- Avoid creating separate model classes and tables for different stages of the same data. Instead, use a single model with additional columns to track progression.
- Record timestamp/user ID pairs for significant transitions of the object (e.g., `submitted_at` and `submitted_by`). This provides a clear audit trail without requiring a separate status column.
- Do not use a status column. Instead, infer the current state of the record from timestamps and other attributes. For example:
  - If `submitted_at` is `NULL`, the record is still in draft mode.
  - If `approved_at` is set, the record has been approved.

## 5.4. File Uploads with S3 & ActiveStorage

If you need to handle any user-submitted files, here is the pattern to do that.

- Store **file attachments** in **ActiveStorage**.
- Use **S3 as the storage backend** for production and **local disk storage** for development/testing.
- Configure **direct uploads via S3** to reduce server load.
- Secure file access with **signed URLs** rather than making files public.
- Use **separate S3 buckets** for production and all staging environments.
- Resize images using **ActiveStorage variants** to reduce bandwidth usage.

## 5.5. Hosting and Deployment  

There are two options listed for hosting: light mode and heavy mode. Both are optional patterns (only write if requested).

### 5.5.1. Light Mode: Hosting and Deployment to a Ubuntu Linux VPS

Here are the approved patterns to deploy to a single web server running Linux.

- Use **Capistrano** for deployment automation.  
- Configure **systemd services** for managing background workers.  
- Set up **automatic security updates** using the `unattended-upgrades` package.  
- Use **Nginx** as a reverse proxy and **Puma** as the application server.  
- Configure **firewall rules** with `ufw` to restrict access.  
- **Only allow SSH login via key authentication** (disable password login).  

### 5.5.2. Heavy Mode: Hosting and Deployment to AWS

Here are the approved patterns to deploy to an AWS cluster for a corporate or high-load application.

- Create a Docker container for the application to run in EC2 with all software necessary for the backend (Redis, etc.).
- Deploy using ECS with Fargate for auto-scaling and simplified management.  
- Overwrite any files containing application secrets using **AWS Secrets Manager**.  
- Use **ALB (Application Load Balancer)** to route traffic.  
- Set up **RDS** with automated backups and failover configurations.  
- Use **AWS Systems Manager (SSM)** for SSH access instead of opening port 22.  

## 5.5. Data Import & ETL (Extract, Transform, Load)  

Sometimes you need to ingest large amounts of data into the application. Here is the approved pattern for that.

- Load **large imports using batch processing** to avoid excessive memory usage.  
- Store **raw imported files in `documents/`** for auditability.  
- Print **detailed progress logs** in case a task has to be aborted in the middle.  
- **Validate data before import** and **log errors** instead of failing the entire import.  
- Use **`activerecord-import`** for **bulk insertions** to minimize DB queries.

## 5.6. Firefighting  

Any data update requested by a user should first be treated as a firefighting request before it is implemented in the UI. Firefighting requests must be executed by a technician using Rake tasks.  

- Rake tasks should be written for all firefighting tasks (in the `ff` namespace).  
- Ensure Firefighting scripts are idempotent (safe to run multiple times without side effects) using guard statements that check if it's been run already.
- Log all progress and results to STDOUT.
- Ensure exceptions are logged to Honeybadger.

### 5.6.1 Firefighting UI

If a firefighting task is used often, it sometimes warrants creating a firefighting UI. This should be restricted to a new role called, `firefighter`, who has access to all accounts in the system. The UI should appear as a series of UI cards. Each task should appear in the UI as a small web form inside a UI card. 

## 5.7 Automated Builds with CircleCI  

As a project gets large, it gets unwieldy to run the entire test suite on every change. Automatic builds with CircleCI and GitHub is the solution to managing complexity in large codebases.

### **Rules**  
- Define pipelines in **`circleci/config.yml`**.  
- Cache dependencies using:  
  ```sh
  bundle install --deployment --path vendor/bundle
  ```
  with caching enabled.  
- Run RSpec tests in parallel jobs to optimize build time.
- Each instance running browser-based (feature) specs should collect all failed tests, and immediately re-run those tests to make sure that they aren't flaky (false negatives).
- CircleCI should run every time a commit is pushed to GitHub.

## 5.8 APIs

When another application must have programmatic access to this application, a RESTful API is preferred.

- Use Apipie to document the API in code.
- Write sample cURL requests for each API route and add it in a comment directly above the controller action.
- Prefer to authenticate with a simple Bearer Token configured as a column on the accounts table.

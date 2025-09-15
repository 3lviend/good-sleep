# Good Sleep API

This is a Rails API application to track sleep records.

## Features
*   **Sleep Tracking**:
    - Clock in sleep sessions
    - Clock out sleep sessions
*   **Sleep Analytics**:
    - Daily summaries with statistics details
*   **Social Features**:
    - Follow users to see followed user sleep reports feeds
    - Block users to prevent unknown followers access sleep reports feeds
*   **Efficient data handling**:
    - Kaminari Pagination
    - Redis actionpack Cache management
    - Ransack search to make data searchable
    - Background job sidekiq scheduler to process user sleep records daily summary
*   **Secure Request**:
    - Low risk of API abuse as implemented rate limiting


## System Dependencies

*   Rails 8.0.2
*   Ruby 3.2.9
*   PostgreSQL
*   Redis (Actionpack)
*   Sidekiq & Sidekiq Scheduler

## Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/your-username/good_sleep.git
    cd good_sleep
    ```

2.  Install the gems:

    ```bash
    bundle install
    ```

3.  Create a `.env` file and add the following environment variables:

    ```
    REDIS_URL=redis://localhost:6379/0
    ```

4.  Create the database and run the migrations:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

## Running the application

This project uses [Foreman](https://github.com/ddollar/foreman) to run multiple processes. To start the application, run:

```bash
foreman start
```

This will start the Rails server on `http://localhost:3000` and Sidekiq for background jobs.

## Development Tools

This project includes several tools to help with development and performance monitoring:

*   **Bullet:** Helps to identify N+1 queries. Warnings are logged to the Rails logger and the `log/bullet.log` file.
*   **QueryTrack:** Tracks slow database queries. Slow queries are logged to the Rails logger.
*   **Annotaterb** Help to provide detailed database Schema Information on development and maintainability.
*   **Rspec** Help to ensure code run as well.
*   **Brakeman** Static analysis tool which checks Ruby on Rails applications to address security vulnerabilities.

## API Documentation

This project uses [Rswag](https://github.com/rswag/rswag) to generate and serve API documentation.

You can access the interactive API documentation at:

*   **Swagger UI:** `http://localhost:3000/api-docs`

The API documentation is automatically generated from the RSpec integration tests.

## Database Indexes

To ensure the application remains fast and responsive, database indexes have been implemented. These indexes act like a table of contents for the database, allowing for quick retrieval of data. Key fields, such as user IDs, dates, and sleep times, are indexed to optimize common queries, such as fetching a user's sleep history or finding their followers. This proactive approach to database performance is crucial for a positive user experience, especially as the amount of data grows.

## Rate Limiting

This project uses [rack-attack](https://github.com/rack/rack-attack) to protect the API from abuse and brute-force attacks. The following rate limiting rules are in place:

*   **General Requests:** All requests are throttled by IP address. A maximum of 5 requests are allowed every 5 seconds from a single IP address.
*   **User Logins:** POST requests to `/api/v1/users` are throttled by IP address. A maximum of 5 requests are allowed every 20 seconds from a single IP address.

## Testing

This project uses RSpec for testing. To run the test suite, use the following commands:

*   **Run all tests:**

    ```bash
    bundle exec rspec
    ```

*   **Run tests in a specific file:**

    ```bash
    bundle exec rspec spec/path/to/your_spec_file.rb
    ```

*   **Run tests in a specific directory:**

    ```bash
    bundle exec rspec spec/path/to/your_spec_directory/
    ```

### Available Tests

This project has the following types of tests:

*   **Model Tests:** These tests cover the application's models and their validations, associations, and methods. You can find them in the `spec/models` directory.
*   **Request Tests:** These tests cover the application's API endpoints and their responses. You can find them in the `spec/requests` directory.
*   **Integration Tests:** These tests cover the application's API endpoints using RSwag for documentation generation. You can find them in the `spec/integration` directory.

## Advanced Improvement

The current search functionality is implemented using the Ransack gem, which is a simple and effective solution for small-scale applications. It allows for easy construction of complex search queries directly from the API.

However, for larger applications with more complex search requirements, a more robust solution would be necessary. As the data grows, Ransack's performance may degrade, as it relies on generating complex SQL queries that can become inefficient.

For more advanced search capabilities, the following alternatives could be considered:

*   **Elasticsearch:** A powerful open-source search and analytics engine that can handle large volumes of data and provide fast, full-text search capabilities. It is highly scalable and offers advanced features like faceting, geolocation, and aggregations.

*   **Algolia:** A hosted search-as-a-service platform that provides a fast and seamless search experience. It is easy to integrate and offers a wide range of features, including typo tolerance, synonyms, and real-time indexing.

*   **Supabase:** While not a dedicated search engine, Supabase provides a suite of tools, including a PostgreSQL database with powerful full-text search capabilities. For applications already using Supabase, its built-in search features can be a good starting point before moving to a more specialized solution.
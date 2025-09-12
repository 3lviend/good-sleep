# Good Sleep API

This is a Rails API application to track sleep records.

## System Dependencies

*   Ruby 3.2.9
*   PostgreSQL
*   Redis

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

## API Documentation

This project uses [Rswag](https://github.com/rswag/rswag) to generate and serve API documentation.

You can access the interactive API documentation at:

*   **Swagger UI:** `http://localhost:3000/api-docs`

The API documentation is automatically generated from the RSpec integration tests.

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
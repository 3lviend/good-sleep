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

## API Endpoints

Here are the main API endpoints available:

*   `POST /api/v1/users/:user_id/sleep_records/:id/clock_in`: Clock in a sleep record.
*   `PUT /api/v1/users/:user_id/sleep_records/:id/clock_out`: Clock out a sleep record.
*   `GET /api/v1/users/:user_id/sleep_records`: Get all sleep records for a user.
*   `GET /api/v1/users/:user_id/sleep_records/daily_sleep_summaries`: Get daily sleep summaries for a user.
*   `GET /api/v1/users/:id`: Get user details.

## Testing

This project uses RSpec for testing. To run the test suite, use the following command:

```bash
# RSpec is not yet configured for this project.
```
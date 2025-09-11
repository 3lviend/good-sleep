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

This documents the available API endpoints based on the output of `rails routes`.

### User Management

*   **List All Users**
    *   Method: `GET`
    *   Path: `/api/v1/users`
*   **Get User Details**
    *   Method: `GET`
    *   Path: `/api/v1/users/:id`

### Following and Followers

*   **List Followed Users**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/follows`
    *   Parameters:
        *   `page`: Page number for pagination.
        *   `per_page`: Number of items per page.
*   **Request to Follow a User**
    *   Method: `POST`
    *   Path: `/api/v1/users/:user_id/follows/request_follow`
    *   Parameters:
        *   `followed_user_id`: ID of the user to follow.
*   **Unfollow a User**
    *   Method: `DELETE`
    *   Path: `/api/v1/users/:user_id/follows/unfollow`
    *   Parameters:
        *   `followed_user_id`: ID of the user to unfollow.
*   **List Followers**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/follows/followers`
    *   Parameters:
        *   `page`: Page number for pagination.
        *   `per_page`: Number of items per page.
*   **List Blocked Users**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/follows/blocked`
    *   Parameters:
        *   `page`: Page number for pagination.
        *   `per_page`: Number of items per page.
*   **Block a Follower**
    *   Method: `PUT` / `PATCH`
    *   Path: `/api/v1/users/:user_id/follows/block_follower`
    *   Parameters:
        *   `follower_user_id`: ID of the follower to block.
*   **Unblock a Follower**
    *   Method: `PUT` / `PATCH`
    *   Path: `/api/v1/users/:user_id/follows/unblock_follower`
    *   Parameters:
        *   `follower_user_id`: ID of the follower to unblock.

### Sleep Records

*   **List Sleep Records**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/sleep_records`
    *   Parameters:
        *   `page`: Page number for pagination.
        *   `per_page`: Number of items per page.
        *   `q[id_eq]`: Filter by exact ID.
        *   `q[sleep_time_gteq]`: Filter by sleep time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01').
        *   `q[sleep_time_lteq]`: Filter by sleep time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00').
        *   `q[sleep_time_between][]`: Filter by sleep time between given datetime begin. (e.g., '2025-09-10 09:21:00').
        *   `q[sleep_time_between][]`: Filter by sleep time between given datetime end. (e.g., '2025-09-10 09:23:00').
        *   `q[awake_time_gteq]`: Filter by awake time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01').
        *   `q[awake_time_lteq]`: Filter by awake time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00').
        *   `q[awake_time_between][]`: Filter by awake time betweeen given datetime begin. (e.g., '2025-09-10 09:21:00').
        *   `q[awake_time_between][]`: Filter by awake time betweeen given datetime end. (e.g., '2025-09-10 10:00:00').
        *   `q[duration_seconds_gteq]`: Filter by duration in seconds greater than or equal to a given value.
        *   `q[duration_seconds_lteq]`: Filter by duration in seconds less than or equal to a given value.
        *   `q[duration_seconds_between][]`: Filter by duration in seconds between given value begin. (e.g., '3600' for 1 hour, '32400' for 9 hours)
        *   `q[duration_seconds_between][]`: Filter by duration in seconds between given value end. (e.g., '3600' for 1 hour, '32400' for 9 hours)
*   **Get a Specific Sleep Record**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/sleep_records/:id`
*   **Clock In**
    *   Method: `POST`
    *   Path: `/api/v1/users/:user_id/sleep_records/clock_in`
*   **Clock Out**
    *   Method: `PUT` / `PATCH`
    *   Path: `/api/v1/users/:user_id/sleep_records/clock_out`

### Sleep Summaries

*   **List Daily Sleep Summaries**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/daily_sleep_summaries`
*   **Get a Specific Daily Sleep Summary**
    *   Method: `GET`
    *   Path: `/api/v1/users/:user_id/daily_sleep_summaries/:id`

## Testing

This project uses RSpec for testing. To run the test suite, use the following command:

```bash
# RSpec is not yet configured for this project.
```
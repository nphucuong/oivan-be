# OIVAN Backend

## Requirements

- ruby 2.7.1p83
- Rails 6.1.3.1

## Database Setup

### Prepare your local database

- change `config/database.yml` as your local db required

### DB setup for Development

- `rails db:create`
- `rails db:migrate`
- `rails teacher:create_first_teacher`

## Running ELXR Backend

- `rails s`

## Running Test

make sure you have `development` and `test` configuration on your `config/database.yml`

- `rspec`

## Outstanding

I applied diversity of skills to show-off. Maybe in real project, we will use alternative gems or solutions.

### User

Using polymorphic to handler roles (teacher, student)

Gem `devise` supports authentication (login, logout)

```
  http://localhost:3000/users/sign_in

  {
  "user": {
      "email": "new_new_teacher@example.com",
      "password": "12345678"
  }
}
```

Get the token in header to use for other endpoints

### Test

When create tests we need to make sure all questions and answers inside the test are valid.

```ruby
  def create
    ActiveRecord::Base.transaction do
      test = Test.create_test(params)
      render_record test
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error_message(e)
  end
```

Otherwise, we will rollback the data and raise error.
Besides that, using service file to help clean code.

### Save Student Result

Using scope and callback to calculate the score of test in model StudentTestResult

### Unit tests

```ruby
  it 'validate json schema' do
    expect(response).to match_response_schema('test/index')
  end
```

I defined a json file to verify data that BE return.

### Serializer

Active Model Serializer

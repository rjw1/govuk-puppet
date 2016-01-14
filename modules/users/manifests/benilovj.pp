# Creates the benilovj user
class users::benilovj {
  govuk::user { 'benilovj':
      fullname => 'Jake Benilov',
      email    => 'jake.benilov@digital.cabinet-office.gov.uk',
      ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwTYWf7H3uBMIXQHsAv5ZZCWAnbqDhpiMzFtqdF4GQXGmUs7dSnDUHCM68BE2M1LSj0TQx7MXvzK6AJiAVFYKw1WZXCbYZpK93Mc6k+IeLAUEMsBIsyw9l5orK+TjKsSBVQ1VktTMCJ38AK5sjhPoLH39kNll96GH++GnnBuSNNsmvq0Ue5WAXf4u0YnYK3XNd6wrYH/RXMXeMDAURMByMSZ6zdoPauU88fG/ZjpCQgBiLtcHe3ivX5Q1mPScdioZV1vm95vyCBDUmAi0C1MZv1Y6L1VDXnxwNX2Q/mtuK33T6MtX+6ubsQwLFUAIZT1pzdmejVi6VKKr6GcOIaSZZ9FE8R9i2iCUz4HXxDiKngN5TE1giFuwOfRsAqyzUmPqIruFnO0WFnOYojkXFt5xm/BXPYNLsD6SyrMWXYBQTuSBzLJ+DngaOcoM24nvx67LuhJrqzbCn76fF5OICUGbod+gOEetY5n8qYOStrrzsUTM91wEoslLiqtQBka6ip8BoftPMwVR6Yo2SBLLKNkEZTwiqIEeQ9+ZQ/Qoxbr5jqxX7DmAqGa97i7VtcZ8CK+cAy0cY6YF8Ov79oac8AmhOIIGqOTc8IpQORsf1yvhNRhKBAKzRfNSzq4EwmGxJPO7avJfqGSRFjR+ib5U6fAYw/a8AWpu33nHc+qmhsCnnuw== benilov@gmail.com',
    }
}

# Insta-Space

![Nebula Image](https://lh3.googleusercontent.com/YGJ77qN9KiwctZgfqV8Bf3hNo0rZvcFaPKDTkvtS6kVbtwyCS80Pm6dpXzJCCLZE1Q)

## Purpose and Usage

Welcome to Insta-Space! You can browse images from Nasa's space exploration (currently Mars Rovers Pictures and Astronomy Picture of the Day photos) and like images you find appealing.

## Installation

First, fork this repository.

Then clone:
```
git clone git@github.com:DavidRMorphew/insta_space_backend.git
```

Run
```
bundle install
```

Then fork, clone, and install the [React Frontend](https://github.com/DavidRMorphew/insta_space_frontend).

## Building for Scale

Nasa Images are "relayed" through this API to the React Frontend without being persisted. Because the NASA Apis require Api tokens, and using Api tokens with Rails is generally more secure than when used with React, images are fetched from the NASA Api, formatted, and then sent with relevant information to the React Frontend without being persisted. You can read more about my choice to relay information [here](https://davidrmorphew.medium.com/relaying-data-through-a-backend-api-6e7baf39619e). Only if liked or commented on will an image be persisted to the database.

## Features Built for the Future

Currently, this Api persists users and provides authentication using JSON Web Tokens and persisted user information and web tokens in localStorage in the React Frontend.

User authentication is intended for future functionality with persisted user likes, comments, and responses to comments. For the future plans to add comments, replies, and persist user likes, see the  [drawio diagram](/Users/Morpheus299800/Projects/coding_challenges/my-insta-space-split/insta-space-backend/insta_space_backend/database_table.png).

This app is also intended to fetch images from other NASA Apis in future versions.

## Contributing

Pull requests are welcome. If you want to make major changes, please open an issue first to discuss the proposed change.

Please feel free to add and update tests where appropriate.

Contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.

## License
The app is open source under the terms of the [MIT License](https://github.com/DavidRMorphew/insta_space_backend/blob/main/LICENSE.TXT).
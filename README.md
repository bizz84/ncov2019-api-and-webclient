# nCoV 2019 Backend REST API and Admin Web Client

This project implements a REST API that is nearly identical to the [nCoV2019 1.0.0 REST API by Nubentos](https://apimarket.nubentos.com/store/apis/info?name=API-nCoV2019&version=1.0.0&provider=owner-AT-nubentos.com&tenant=nubentos.com).

This API is available for educational purposes, and was developed for my [Flutter REST API Crash Course](https://courses.codewithandrea.com/).

An Admin Dashboard is available at [ncov2019-admin.firebaseapp.com](https://ncov2019-admin.firebaseapp.com/#/), and supports the following features:

- User authentication
- Generate authentication (or API) keys
- Generate access tokens
- Preview and test all the API endpoints

The API can be used to query global number of cases for COVID-19. Country-specific data is **not** available.

This project contains two folders:

- **api**: contains the REST API backend, built with Firestore and Cloud Functions
- **web_client**: Flutter Web Admin Dashboard, which is published [here](https://ncov2019-admin.firebaseapp.com/#/).

[LICENSE: MIT](LICENSE.md)



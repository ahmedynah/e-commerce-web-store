# e-commerce-web-store

## Content

- [Introduction](#introduction)
- [Domain](#domain)
- [Vision](#vision)
- [Features](#features)
- [Functional Requirements](#functional-requirements)
    - [Store Owner Requirements](#the-store-owner-requirements)
    - [Customer Requirements](#the-customer-requirements)
- [Non-Functional Requirements](#non-functional-requirements)
- [Constraints](#constraints)
- [Assumptions](#assumptions)
- [Actors](#actors)
- [Use Cases](#use-cases)
- [Data Model](#data-model)
- [Store Owner Dashboard](#store-owner-dashboard)
- [Customer Dashboard](#customer-dashboard)


## Introduction

This project is an e-commerce web store designed to facilitate online shopping and tracking orders efficiently for customers and provide the store owner with a comprehensive dashboard to manage his or her products, orders, and customers. The platform aims to deliver a seamless shopping experience while ensuring efficient store management.

## Domain

The domain of this project is e-commerce, focusing on online retail and digital storefront management. It encompasses functionalities for both customers and store owners, including product browsing, order placement, order tracking, and administrative management of products, orders, and customer information.

## Vision

The vision of this project is to create a user-friendly and efficient e-commerce platform that enhances the online shopping experience for customers while providing store owners with powerful tools to manage their business effectively. The platform aims to streamline the shopping and management processes, ensuring customer satisfaction and operational efficiency.

## Features

The key features of this e-commerce web store include:
- To allow people to select from products, place an order, and track their order status, all from their browser.
- To allow the store owner to manage product inventory in the web store.
- To provide a reporting capability to the store owner on the success of the e-commerce venture.

## Functional Requirements

- ### The store owner requirements
    - The web store must display the products that are available, so that
    customers can see them, and thus want to purchase them.
    - Products must be searchable and organized into categories and subcategories.
    - The store owner needs private administrative pages (protected by an owner ID and password) to add, update, and remove products. Crucially, if a product has **any sales history, it cannot be hard-deleted** without corrupting historical order records. Instead, products require a **status indicator (** **active** **/** **deleted** **)** so they can be hidden from shoppers while preserving history.
    - Generate reports and answer questions :
        - Which products or categories sold the most/least.
        - Which customer types bought which products.
        - Whether special discounts were effective.
    - Because the store owner handles fulfillment directly, orders must capture products ordered, quantities, discounts, total shipping cost, taxes (if any), and total cost.

- ### The customer requirements
    - To complete a purchase, a customer only needs to provide **valid payment authorization** and **shipping details** (name and shipping address). As a rule of thumb, **all optional customer profile items should remain optional**—forcing users to fill out intrusive fields on order forms leads to abandoned orders.
    - Restrict storing personal data beyond the bare minimum without explicit consent.
    - Asking for an **e-mail address** enables shipping confirmations, while allowing customers to return and track orders requires storing a **customer ID and password**.
    - Payment data is handed off to a **third-party payment processor** (such as Authorize.Net, LinkPoint International, VeriSign Inc., PayPal, or 2CheckOut.Com), and the database simply records the returned outcome (`"payment approved"` or `"payment denied"`).

## Non-Functional Requirements
- Minimal response time for user interactions to ensure a smooth shopping experience.
- High availability to ensure the platform is accessible to users at all times.
- Scalability to handle increasing numbers of users and transactions efficiently.
- Security measures to protect sensitive customer and payment data.
- Cross-browser compatibility to provide a consistent experience across different web browsers.
- Mobile responsiveness to ensure usability on various devices, including smartphones and tablets.

## Constraints
- The database must be capable of handling product, order, and customer data efficiently.
- The system should comply with relevant data protection and privacy regulations.
- The application must be deployable on common web servers and cloud platforms.
- The platform should support integration with third-party services such as payment gateways and shipping providers.

## Assumptions
- The store owner has the necessary technical skills to manage the web store and its database.
- Customers have access to the internet and a web browser to interact with the store.
- The third-party payment processor is reliable and handles payment transactions securely.
- Shipping providers are capable of delivering orders to the specified addresses in a timely manner.
- The system will be maintained and updated regularly to ensure security and performance.

## Data Model
# retroui-rails

## What is this?

`retroui-rails` is a Rails/ViewComponent port of RetroUI's Tailwind-first component model.

It is not a plain CSS component gem. Components render Tailwind utility classes directly, and Tailwind is required in the host application. The intent is similar to shadcn-style ownership: install the gem, render components, then vendor the component source when you want to own and modify it.

## Installation

Add the gem to your Rails app:

```ruby
gem "retroui-rails"
```

Then run:

```sh
bundle install
rails generate retro_ui:install
```

`retroui-rails` depends on Rails, ViewComponent, and Stimulus for interactive Hotwire components. It does not require React, Node, or vendored fonts.

## Tailwind setup

The host app must compile Tailwind classes used by gem components. There is no Tailwind-free fallback.

Include the RetroUI theme tokens in a stylesheet compiled by your app:

```css
@import "retro_ui/rails/theme.css";
```

Configure Tailwind to scan the classes used by:

- app-owned components, such as `app/components/**/*.{rb,erb}`
- gem-provided components, such as the installed gem's `app/components/retro_ui/rails/**/*.{rb,erb}`
- vendored components, such as `app/components/retro_ui/**/*.{rb,erb}`

If your Tailwind setup cannot scan gem files reliably, vendor the components:

```sh
rails generate retro_ui:vendor
```

## Using components

```erb
<%= render RetroUI::Rails::ButtonComponent.new(label: "Start") %>

<%= render RetroUI::Rails::ButtonComponent.new(href: "/docs", variant: :secondary) do %>
  Read Docs
<% end %>

<%= render RetroUI::Rails::BadgeComponent.new(variant: :secondary) do %>
  New
<% end %>

<%= render RetroUI::Rails::AlertComponent.new do %>
  <%= render RetroUI::Rails::AlertTitleComponent.new do %>
    Autosave complete
  <% end %>
  <%= render RetroUI::Rails::AlertDescriptionComponent.new do %>
    Your changes are safely tucked away.
  <% end %>
<% end %>

<%= render RetroUI::Rails::LabelComponent.new(text: "Email", for_id: "email") %>
<%= render RetroUI::Rails::InputComponent.new(type: :email, name: "email", html_options: { id: "email" }) %>
<%= render RetroUI::Rails::TextareaComponent.new(name: "message") %>
<%= render RetroUI::Rails::CheckboxComponent.new(name: "confirm") %>
<%= render RetroUI::Rails::RadioComponent.new(name: "plan", value: "pro") %>
<%= render RetroUI::Rails::SelectComponent.new(name: "size", options: [["Small", "s"], ["Large", "l"]]) %>

<%= render RetroUI::Rails::SeparatorComponent.new %>
<%= render RetroUI::Rails::SkeletonComponent.new(html_options: { class: "h-8 w-full" }) %>
<%= render RetroUI::Rails::ProgressComponent.new(value: 40) %>
<%= render RetroUI::Rails::SwitchComponent.new(name: "enabled") %>

<%= render RetroUI::Rails::AvatarComponent.new do %>
  <%= render RetroUI::Rails::AvatarFallbackComponent.new(text: "RU") %>
<% end %>

<%= render RetroUI::Rails::AspectRatioComponent.new(ratio: "16/9") do %>
  <img src="/preview.png" alt="Preview" class="h-full w-full object-cover">
<% end %>

<%= render RetroUI::Rails::BreadcrumbComponent.new do %>
  <%= render RetroUI::Rails::BreadcrumbListComponent.new do %>
    <%= render RetroUI::Rails::BreadcrumbItemComponent.new do %>
      <%= render RetroUI::Rails::BreadcrumbLinkComponent.new(href: "/", text: "Home") %>
    <% end %>
    <%= render RetroUI::Rails::BreadcrumbSeparatorComponent.new %>
    <%= render RetroUI::Rails::BreadcrumbItemComponent.new do %>
      <%= render RetroUI::Rails::BreadcrumbPageComponent.new(text: "Docs") %>
    <% end %>
  <% end %>
<% end %>

<%= render RetroUI::Rails::PaginationComponent.new do %>
  <%= render RetroUI::Rails::PaginationContentComponent.new do %>
    <%= render RetroUI::Rails::PaginationItemComponent.new do %>
      <%= render RetroUI::Rails::PaginationLinkComponent.new(href: "?page=1", label: "1", active: true) %>
    <% end %>
  <% end %>
<% end %>

<%= render RetroUI::Rails::TypographyComponent.new(as: :h2, text: "Inventory") %>
<%= render RetroUI::Rails::CodeComponent.new(text: "rails generate retro_ui:vendor") %>
<%= render RetroUI::Rails::KbdComponent.new(text: "K") %>

<%= render RetroUI::Rails::ToastViewportComponent.new do %>
  <%= render RetroUI::Rails::ToastComponent.new(duration: 4000) do %>
    <%= render RetroUI::Rails::ToastTitleComponent.new(text: "Saved") %>
    <%= render RetroUI::Rails::ToastDescriptionComponent.new(text: "Your changes were saved.") %>
    <%= render RetroUI::Rails::ToastCloseComponent.new %>
  <% end %>
<% end %>

<%= render RetroUI::Rails::CardComponent.new do %>
  <%= render RetroUI::Rails::CardHeaderComponent.new do %>
    <%= render RetroUI::Rails::CardTitleComponent.new do %>
      Save Point
    <% end %>
    <%= render RetroUI::Rails::CardDescriptionComponent.new do %>
      Your progress is mostly imaginary.
    <% end %>
  <% end %>

  <%= render RetroUI::Rails::CardContentComponent.new do %>
    Continue?
  <% end %>
<% end %>

<%= render RetroUI::Rails::TableComponent.new do %>
  <%= render RetroUI::Rails::TableHeaderComponent.new do %>
    <%= render RetroUI::Rails::TableRowComponent.new do %>
      <%= render RetroUI::Rails::TableHeadComponent.new do %>Quest<% end %>
      <%= render RetroUI::Rails::TableHeadComponent.new do %>Status<% end %>
    <% end %>
  <% end %>
  <%= render RetroUI::Rails::TableBodyComponent.new do %>
    <%= render RetroUI::Rails::TableRowComponent.new do %>
      <%= render RetroUI::Rails::TableCellComponent.new do %>Ship gem<% end %>
      <%= render RetroUI::Rails::TableCellComponent.new do %>In progress<% end %>
    <% end %>
  <% end %>
<% end %>
```

Hotwire-backed components use Stimulus controllers. Register the toast controller with your Stimulus application:

```ruby
# config/importmap.rb
pin "retro_ui/rails/controllers/toast_controller", to: "retro_ui/rails/controllers/toast_controller.js"
```

```js
import ToastController from "retro_ui/rails/controllers/toast_controller"

application.register("retro-ui--toast", ToastController)
```

## Theme tokens

The theme stylesheet defines CSS variables only. Component styling remains in Tailwind utility classes.

Tokens include background, foreground, card, primary, secondary, muted, accent, destructive, border, and hard offset shadow variables. Configure Tailwind colors and shadows to read from these variables so utilities such as `bg-primary`, `text-primary-foreground`, `bg-card`, `border-border`, and `shadow-md` resolve to the RetroUI theme.

## Vendoring for customization

Vendoring copies the current gem component source into your application:

```sh
rails generate retro_ui:vendor
```

Files are copied to `app/components/retro_ui`, `app/javascript/controllers/retro_ui`, and `app/assets/stylesheets/retro_ui/theme.css`. Namespaces are rewritten from `RetroUI::Rails` to `RetroUI`, so vendored components are application code and do not depend on the engine namespace.

Vendored components currently include button, card, badge, alert, input, textarea, label, checkbox, radio, select, separator, skeleton, progress, table, avatar, aspect ratio, breadcrumb, pagination, typography, code, kbd, switch, and toast primitives.

Existing files are not overwritten unless you pass `--force`:

```sh
rails generate retro_ui:vendor --force
```

Future gem updates will not automatically alter vendored copies.

## Development

Install dependencies and run the test suite:

```sh
bundle install
bundle exec rspec
```

The test dummy app lives in `spec/dummy`.

Run the dummy demo app:

```sh
cd spec/dummy
bundle exec ruby bin/rails server -b 127.0.0.1 -p 3000
```

Then open `http://127.0.0.1:3000/`.

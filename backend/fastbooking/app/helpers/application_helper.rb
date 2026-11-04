module ApplicationHelper
  def cover_image(record, css_class: "cover")
    if record.photos.attached?
      image_tag record.photos.first, class: css_class, alt: record.try(:name).to_s
    else
      content_tag(:div, class: "#{css_class} photo-placeholder") do
        content_tag(:span, record.try(:name).to_s.strip.first.to_s.upcase)
      end
    end
  end

  def money(amount)
    return "—" if amount.nil?
    number_to_currency(amount, unit: "₽", separator: ",", delimiter: " ", format: "%n %u", precision: 0)
  end

  def rating_badge(hotel)
    average = hotel.average_rating
    return content_tag(:span, "Нет отзывов", class: "badge badge--muted") if average.nil?

    content_tag(:span, class: "badge badge--rating") do
      "⭐ #{average} / 5 · #{hotel.reviews_count}"
    end
  end

  def booking_status_badge(booking)
    if booking.pending?
      content_tag(:span, "Ожидает подтверждения", class: "badge badge--warning")
    elsif booking.cancelled?
      content_tag(:span, "Отклонено", class: "badge badge--danger")
    elsif booking.completed?
      content_tag(:span, "Завершено", class: "badge badge--muted")
    else
      content_tag(:span, "Подтверждено", class: "badge badge--success")
    end
  end

  def flash_class(type)
    case type.to_sym
    when :notice then "flash--success"
    when :alert  then "flash--danger"
    else "flash--info"
    end
  end

  def nights_label(nights)
    "#{nights} #{Russian.plural(nights, 'ночь', 'ночи', 'ночей')}"
  end
end

module Russian
  module_function

  def plural(number, one, few, many)
    mod10 = number % 10
    mod100 = number % 100

    return many if (11..14).cover?(mod100)
    return one if mod10 == 1
    return few if (2..4).cover?(mod10)

    many
  end
end

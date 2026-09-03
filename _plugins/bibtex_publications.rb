# frozen_string_literal: true

# Build-time BibTeX reader. This keeps My-paper.bib as the only publication
# source: every Jekyll build refreshes site.data.publications before rendering.
module BibtexPublications
  module_function

  def read_value(body, start)
    index = start
    index += 1 while index < body.length && body[index] =~ /\s/
    return ["", index] if index >= body.length

    opening = body[index]
    if opening == "{" || opening == '"'
      closing = opening == "{" ? "}" : '"'
      depth = 0
      cursor = index
      while cursor < body.length
        if body[cursor] == "\\"
          cursor += 2
          next
        end
        depth += 1 if body[cursor] == opening
        if body[cursor] == closing
          depth -= 1
          return [body[(index + 1)...cursor], cursor + 1] if depth.zero?
        end
        cursor += 1
      end
      return [body[(index + 1)..], body.length]
    end

    ending = body.index(",", index) || body.length
    [body[index...ending].strip, ending]
  end

  def parse(text)
    entries = []
    entry_pattern = /@\w+\s*\{\s*([^,]+),/i
    offset = 0
    while (match = entry_pattern.match(text, offset))
      depth = 1
      cursor = match.end(0)
      while cursor < text.length && depth.positive?
        if text[cursor] == "\\"
          cursor += 2
          next
        end
        depth += 1 if text[cursor] == "{"
        depth -= 1 if text[cursor] == "}"
        cursor += 1
      end
      body = text[match.end(0)...(cursor - 1)]
      fields = { "key" => match[1].strip }
      field_pattern = /(?:\A|,)\s*([A-Za-z][A-Za-z0-9_-]*)\s*=\s*/
      field_offset = 0
      while (field = field_pattern.match(body, field_offset))
        value, next_offset = read_value(body, field.end(0))
        fields[field[1].downcase] = value.strip
        field_offset = [next_offset, field.end(0) + 1].max
      end
      entries << fields
      offset = cursor
    end
    entries
  end

  def clean(value)
    value.to_s.gsub("\\&", "&").gsub("--", "–").gsub(/[{}]/, "").strip
  end

  def initials(given)
    given = clean(given)
    return given if given.include?(".")

    given.scan(/[A-Za-zÀ-ÖØ-öø-ÿ]+/).map { |word| "#{word[0]}." }.join(" ")
  end

  def format_authors(author_field)
    authors = author_field.to_s.split(/\s+and\s+/i).map do |raw|
      raw = clean(raw)
      if raw.include?(",")
        surname, given = raw.split(",", 2).map(&:strip)
        "#{surname}, #{initials(given)}"
      else
        raw
      end
    end
    formatted = if authors.length <= 1
                  authors.first.to_s
                else
                  "#{authors[0...-1].join(', ')}, & #{authors[-1]}"
                end
    [formatted, authors.first.to_s.start_with?("Cao,")]
  end

  def record(entry)
    authors, first_author = format_authors(entry["author"])
    year = (entry["year"].to_s[/\d{4}/] || "1900").to_i
    working = entry["keywords"].to_s.downcase.include?("working")
    title = clean(entry["title"])
    journal = clean(entry["journal"])
    reference = "#{authors} (#{year}). #{title}. #{journal}"
    reference += ", #{clean(entry['volume'])}" if entry["volume"]
    reference += "(#{clean(entry['number'])})" if entry["number"]
    reference += ", #{clean(entry['pages'])}" if entry["pages"]
    reference += "."

    data = {
      "key" => entry["key"],
      "category" => working ? "working_papers" : "manuscripts",
      "year" => year,
      "first_author" => first_author,
      "selected" => first_author && !working,
      "reference" => reference,
      "title" => title,
      "journal" => journal
    }
    %w[volume number pages doi].each { |field| data[field] = clean(entry[field]) if entry[field] }
    data
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  bib_path = File.join(site.source, "My-paper.bib")
  next unless File.file?(bib_path)

  bib_text = File.read(bib_path, encoding: "UTF-8")
  records = BibtexPublications.parse(bib_text).map { |entry| BibtexPublications.record(entry) }
  site.data["publications"] = records.sort_by { |item| [item["year"], item["key"]] }.reverse
end

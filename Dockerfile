FROM ruby:2.4.1
MAINTAINER Kevin Coleman kevinjamescoleman.7@gmail.com

# Install apt based dependencies required to run Rails.
RUN apt-get update && apt-get install -y \
  build-essential

# Install node
RUN wget -qO- https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN npm install --global yarn

# Copy the app.
ENV app /app
RUN mkdir -p $app
WORKDIR $app
ADD . $app

# Set the gem directory to be a volume and check if gems are installed.
# If not, install them.
ENV BUNDLE_PATH /gems
RUN bundle check || bundle install
RUN gem install foreman

# Expose port 3000 to the host so that it is accessible.
EXPOSE 3000

CMD ["foreman start"]
